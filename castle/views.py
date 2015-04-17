from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect, Http404
from castle.models import *
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.core.urlresolvers import reverse
from django.db import transaction
from django.db.models import Sum, Avg
from random import randint
from django.db.models import Q
from django.utils.http import urlquote_plus, urlquote
from datetime import datetime
import math
import re

#-----------------------------------------------------------------------------
# Global symbols
#-----------------------------------------------------------------------------
PAGE_COMMENTS   = 15
PAGE_STORIES    = 15
PAGE_BROWSE     = 3 #0
PAGE_PROMPTS    = 20
PAGE_BLOG       = 10

#-----------------------------------------------------------------------------
# Query functions
#-----------------------------------------------------------------------------
def get_popular_stories(page_num=1, page_size=10):
    # FIXME: this code is MySQL specific
    r = Story.objects.raw(
        "SELECT s.id as id, " +
        "SUM(1/(TIMESTAMPDIFF(day, l.ctime, NOW())+1)) AS score " +
        "FROM castle_storylog AS l " +
        "LEFT JOIN castle_story AS s ON s.id=l.story_id " +
        "WHERE l.user_id != s.user_id " +
        "AND l.log_type = " + str(StoryLog.VIEW) + " "+
        "AND ((s.draft IS NULL) OR (NOT s.draft)) " +
        "GROUP BY l.story_id ORDER BY score DESC LIMIT " +
        str((page_num-1) * page_size) + "," + str(page_size))
    return r

#-----------------------------------------------------------------------------
def get_active_stories(page_num=1, page_size=10):
    first = (page_num-1) * page_size
    last  = first + page_size
    return Story.objects.filter(activity__gt = 0).order_by('activity')[first:last]
    
#-----------------------------------------------------------------------------
def get_num_active_stories():
    return Story.objects.filter(activity__gt = 0).count()
    
#-----------------------------------------------------------------------------
def get_recent_stories(page_num=1, page_size=10):
    first = (page_num-1) * page_size
    last  = first + page_size
    return Story.objects.filter(draft = False).order_by('-ptime')[first:last]
    
#-----------------------------------------------------------------------------
def get_old_stories(page_size=10):
    total = Story.objects.filter(draft = False).count()
    end = 0 if (total < page_size) else (total - page_size)
    first = randint(0, end)
    last  = first + page_size
    return Story.objects.filter(draft = False).order_by('ptime')[first:last]
    
#-----------------------------------------------------------------------------
def get_activity_log(profile, entries):
    log_entries = StoryLog.objects.exclude(log_type = StoryLog.VIEW).exclude(log_type = StoryLog.RATE).filter(Q(user = profile) | Q(story__user = profile)).order_by('ctime')[:entries]
    
    return log_entries

#-----------------------------------------------------------------------------
# Pager
#-----------------------------------------------------------------------------
def bs_pager(cur_page, page_size, num_items):
    
    num_pages = int(math.ceil(num_items / (page_size+0.0)))
    
    # No need for a pager if we have fewer than two pages
    if (num_pages < 2):
        return None
    
    # Empty list
    page_nums = []
    
    if (cur_page > 1):  # Previous page mark if we're not on page 1
        page_nums.append(('P', cur_page-1));
    
    if (num_pages < 11):
        # Fewer than 13 pages, list them all
        for n in range(1, num_pages+1):
            if (n == cur_page):
                page_nums.append(('C', n))      # Current page
            else:
                page_nums.append(('G',n))       # Go to page n
    else:
        # More than ten pages, we have three cases here
        # We aim to show the current page, and 4 pages either side of
        # the current page.  At each end we always show the first two and
        # and the last two pages.
        #   case 1: cur_page near the start
        #   case 2: cur_page near the end
        #   case 3: cur_page not near either end
        if (cur_page < 6):
            for n in range(1, 10):
                if (n == cur_page):
                    page_nums.append(('C', n))  # Current page
                else:
                    page_nums.append(('G',n))   # Go to page n
            page_nums.append(('S', 0))          # Separator goes here
            page_nums.append(('G', num_pages-1))# then last two pages
            page_nums.append(('G', num_pages))
        elif (cur_page >= (num_pages-5)):
            # First two pages go here, then a separator
            page_nums.append(('G', 1))
            page_nums.append(('G', 2))
            page_nums.append(('S', 0))    # Separator goes here
            # Then the last nine pages
            for n in range (num_pages-8, num_pages+1):
                if (n == cur_page):
                    page_nums.append(('C', n))  # Current page
                else:
                    page_nums.append(('G',n))   # Go to page n
        else:
            # First two pages, a separator, then nine pages in the middle,
            # then another separator, then the last two.
            page_nums.append(('G', 1))
            page_nums.append(('G', 2))
            page_nums.append(('S', 0))    # Separator goes here
            # Then the last nine pages
            for n in range (cur_page-3, cur_page+4):
                if (n == cur_page):
                    page_nums.append(('C', n))  # Current page
                else:
                    page_nums.append(('G',n))   # Go to page n
            page_nums.append(('S', 0))    # Separator goes here
            page_nums.append(('G', num_pages-1))# then last two pages
            page_nums.append(('G', num_pages))

    if (cur_page < num_pages):  # Next page mark if we're not last page
        page_nums.append(('N', cur_page+1))
    
    return page_nums

#-----------------------------------------------------------------------------
# Helper functions
#-----------------------------------------------------------------------------
def get_foo(request, foo, key):
    """Uses a request.POST or a request.GET enquiry to attempt to
       get hold of a named GET or POST parameter and look it up in the
       relevant database
       eg. to use the GET field 'sid' as a key in the Story table, use
       
       get_foo(request.GET, Story, 'sid')
       """
    sid = request.get(key, None)
    if ((sid is None) or (sid == '') or (sid == 'None')):  # Text 'None' results in None return
        return None
    
    # The id may be invalid; the story may not exist.
    # Return it if it's there or None otherwise
    sl = foo.objects.filter(pk=sid)
    if (sl):
        return sl[0]
    else:
        return None

#-----------------------------------------------------------------------------
def safe_int(v, default=1):
    try:
        return int(v)
    except ValueError:
        return default

#-----------------------------------------------------------------------------
# Views
#-----------------------------------------------------------------------------
def home(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    # Get featured story
    featured_id = Misc.objects.filter(key='featured')
    featured = None
    if (featured_id):
        featured_query = Story.objects.filter(id=featured_id[0].i_val)
        if (featured_query):
            featured = featured_query[0]
        
    # Build context and render page
    context = { 'profile'       : profile,
                'blog_latest'   : Blog.objects.all().order_by('-id')[0],
                'featured'      : featured,
                'popular'       : get_popular_stories(1,4),
                'active'        : get_active_stories(1,10),
                'recent'        : get_recent_stories(1,10),
                'old'           : get_old_stories(10),
                'activity_log'  : get_activity_log(profile, 10),
                'user_dashboard': 1,
              }
    return render(request, 'castle/index.html', context)

#-----------------------------------------------------------------------------
def author(request, pen_name):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    # Get target author's information
    author = Profile.objects.filter(pen_name_uc = pen_name.upper())
    if (not author):
        raise Http404()
    author = author[0]          # Get single object from collection

    # Is logged-in user the author?
    owner = ((profile is not None) and (profile == author))

    # Build story list (owner sees their drafts)
    page_num = safe_int(request.GET.get('page_num', 1))
    if (owner):
        num_stories = Story.objects.filter(user = author).count()
        story_list = Story.objects.filter(user = author).order_by('-draft','-ptime','-mtime')[(page_num-1)*PAGE_STORIES:page_num*PAGE_STORIES]
    else:
        num_stories=Story.objects.filter(user = author, draft = False).count()
        story_list=Story.objects.filter(user = author, draft = False).order_by('-ptime')[(page_num-1)*PAGE_STORIES:page_num*PAGE_STORIES]

    # Build context and render page
    context = { 'profile'       : profile,
                'author'        : author,
                'story_list'    : story_list,
                'page_url'      : u'/authors/'+urlquote(author.pen_name)+u'/',
                'pages'         : bs_pager(page_num, PAGE_STORIES, num_stories),
                'user_dashboard': owner,
                'other_user_sidepanel' : (not owner),
            }
    return render(request, 'castle/author.html', context)

#-----------------------------------------------------------------------------
def signin(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            login(request, user)
            return HttpResponseRedirect(reverse('home'))
        else:
            return HttpResponse("Account disabled")
    else:
        return HttpResponse("Log in failed")

#-----------------------------------------------------------------------------
def signout(request):
    logout(request)
    return HttpResponseRedirect(reverse('home'))

#-----------------------------------------------------------------------------
# Story views
#-----------------------------------------------------------------------------
def story_view(request, story_id, comment_text=None, user_rating=None, error_title='', error_messages=None):
    story = get_object_or_404(Story, pk=story_id)
    
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Is logged-in user the author?
    author = story.user
    owner = ((profile is not None) and (profile == author))

    # Collect prequels and sequels
    prequels = []
    if (story.sequel_to):
        prequels.append(story.sequel_to)
    prequels.extend(story.prequels.all())

    sequels = []
    if (story.prequel_to):
        sequels.append(story.prequel_to)
    sequels.extend(story.sequels.all())

    # Get user rating in numeric and string forms
    rating = Rating.objects.filter(story=story).exclude(user=story.user).aggregate(avg=Avg('rating'))['avg']
    rating_str = u'{:.2f}'.format(rating) if (rating) else ''
    
    # Get comments
    page_num = safe_int(request.GET.get('page_num', 1))
    comments = story.comment_set.all().order_by('ctime')[(page_num-1)*PAGE_COMMENTS:page_num*PAGE_COMMENTS]

    # Count how many times the story has been viewed and rated
    viewed = StoryLog.objects.filter(story = story).exclude(user = author).count()
    rated  = Rating.objects.filter(story = story).exclude(user=author).count()

    # Get current user's rating
    if ((profile) and (user_rating is None)):
        rating_set = Rating.objects.filter(story=story, user=profile)
        if (rating_set):
            user_rating = rating_set[0].rating

    # Build context and render page
    context = { 'profile'       : profile,
                'author'        : story.user,
                'story'         : story,
                'prequels'      : prequels,
                'sequels'       : sequels,
                'rating_str'    : rating_str,
                'rating_num'    : rating,
                'comments'      : comments,
                'page_url'      : u'/stories/'+unicode(story_id)+u'/',
                'pages'         : bs_pager(page_num, PAGE_COMMENTS, story.comment_set.count()),
                'story_sidepanel':1 ,
                'owner'         : owner,
                'viewed'        : viewed,
                'rated'         : rated,
                'comment_text'  : comment_text, # in case of failed comment submission
                'user_rating'   : user_rating,
                'error_title'   : error_title,
                'error_messages': error_messages,
            }
    return render(request, 'castle/story.html', context)

#-----------------------------------------------------------------------------
@login_required
def new_story(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get prequel, sequel and prompt data from the GET request
    prequel_to = get_foo(request.GET, Story,  'prequel_to')
    sequel_to  = get_foo(request.GET, Story,  'sequel_to')
    prompt     = get_foo(request.GET, Prompt, 'prid')

    # Create a blank story to give the template some defaults
    story = Story(prequel_to = prequel_to,
                  sequel_to  = sequel_to,
                  prompt     = prompt)

    # Build context and render page
    context = { 'profile'       : profile,
                'story'         : story,
                'tags'          : u'',
                'length_limit'  : 1024,
                'length_min'    : 60,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_story.html', context)

#-----------------------------------------------------------------------------
@login_required
def edit_story(request, story_id):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get story
    story = get_object_or_404(Story, pk=story_id)
    
    # User can only edit their own stories
    if (story.user != profile):
        raise Http404
    
    # Get tags
    tags = ", ".join(story.tag_set.values_list('tag', flat=True))

    # Build context and render page
    context = { 'profile'       : profile,
                'story'         : story,
                'tags'          : tags,
                'length_limit'  : 1024,
                'length_min'    : 60,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_story.html', context)

#-----------------------------------------------------------------------------
@login_required
@transaction.atomic
def submit_story(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get bits and bobs
    errors     = []
    story      = get_foo(request.POST, Story,  'sid')
    prequel_to = get_foo(request.POST, Story,  'prequel_to')
    sequel_to  = get_foo(request.POST, Story,  'sequel_to')
    prompt     = get_foo(request.POST, Prompt, 'prid')
    tags       = request.POST.get('tag_list', '')
    new_story  = (story is None)
    was_draft  = False
    if (not new_story):         # Remember if the story was draft
        was_draft = story.draft

    if (not profile.email_authenticated()):
        errors.append(u'You must have authenticated your e-mail address before posting a story');
    else:
        # Get story object, either existing or new
        if (story is None):
            story = Story(user       = profile,
                          prequel_to = prequel_to,
                          sequel_to  = sequel_to,
                          prompt     = prompt)

        # Populate story object with data from submitted form
        story.title  = request.POST.get('title', '')
        story.body   = request.POST.get('body', '')
        story.mature = request.POST.get('is_mature', False)
        story.draft  = request.POST.get('is_draft', False)
                
        # Check for submission errors
        if (len(story.title) < 1):
            errors.append(u'Story title must be at least 1 character long')
        
        l = len(story.body)
        if ((not story.draft) and (l < 60)):
            errors.append(u'Story body must be at least 60 characters long')
        
        if ((not story.draft) and (l > 1024)):
            errors.append(u'Story is over 1024 characters (currently ' + unicode(l) + u')')

        if ((    story.draft) and (l > 1536)):
            errors.append(u'Draft is over 1536 characters (currently ' + unicode(l) + u')')
    
    # If there have been errors, re-display the page
    if (errors):
    # Build context and render page
        context = { 'profile'       : profile,
                    'story'         : story,
                    'tags'          : tags,
                    'length_limit'  : 1024,
                    'length_min'    : 60,
                    'user_dashboard': 1,
                    'error_title'   : 'Story submission unsuccessful',
                    'error_messages': errors,
                }

        return render(request, 'castle/edit_story.html', context)

    # Is the story being published?
    if (not story.draft and (was_draft or new_story)):
        story.ptime = datetime.now()
    
    # Set modification time
    story.mtime = datetime.now()
    
    # No problems, update the database and redirect
    story.save()
    
    # Populate tags list
    r = re.compile(r'\s*,\s*')
    tag_list = r.split(tags.upper())
    td = {}
    
    if (not new_story):
        # Remove old tags on current story before laying the new ones down
        story.tag_set.all().delete()
    for t in tag_list:
        if (len(t) > 1):
            if (t not in td):   # Strip out duplicates using dict 'td'
                td[t] = 1
                tag_object = Tag(story=story, tag=t)
                tag_object.save()
            
    return HttpResponseRedirect(reverse('story', args=(story.id,)))

#-----------------------------------------------------------------------------
def browse_stories(request, dataset=0):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    page_num = safe_int(request.GET.get('page_num', 1))
    
    if (dataset == 1):
        stories = get_active_stories(page_num, PAGE_BROWSE)
        num_stories = get_num_active_stories()
        label = u'Active stories'
        url = u'/stories/active/'
    elif (dataset == 2):
        stories = get_popular_stories(page_num, PAGE_BROWSE)
        num_stories = Story.objects.exclude(draft = True).count()
        label = u'Popular stories'
        url = u'/stories/popular/'
    else:
        stories = get_recent_stories(page_num, PAGE_BROWSE)
        num_stories = Story.objects.exclude(draft = True).count()
        label = u'Recent stories'
        url = u'/stories/'

    # Build context and render page
    context = { 'profile'       : profile,
                'stories'       : stories,
                'page_url'      : url,
                'pages'         : bs_pager(page_num, PAGE_BROWSE, num_stories),
                'user_dashboard': 1,
                'label'         : label,
              }
    return render(request, 'castle/browse.html', context)

#-----------------------------------------------------------------------------
def active_stories(request):
    return browse_stories(request, 1)

#-----------------------------------------------------------------------------
def popular_stories(request):
    return browse_stories(request, 2)

#-----------------------------------------------------------------------------
# Prompt views
#-----------------------------------------------------------------------------
def prompts(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get prompts
    page_num = safe_int(request.GET.get('page_num', 1))
    prompts = Prompt.objects.all().order_by('ctime')[(page_num-1)*PAGE_PROMPTS:page_num*PAGE_PROMPTS]
    num_prompts = Prompt.objects.all().count()

    # Build context and render page
    context = { 'profile'       : profile,
                'prompts'       : prompts,
                'prompt_button' : (profile is not None),
                'user_dashboard': (profile is not None),
                'page_url'      : u'/prompts/',
                'pages'         : bs_pager(page_num, PAGE_PROMPTS, num_prompts),
            }
    

    return render(request, 'castle/prompts.html', context)

#-----------------------------------------------------------------------------
def prompt(request, prompt_id):
    # Get story
    prompt = get_object_or_404(Prompt, pk=prompt_id)

    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get stories inspired by prompt
    page_num = safe_int(request.GET.get('page_num', 1))
    stories = prompt.story_set.exclude(draft=True).order_by('ctime')[(page_num-1)*PAGE_STORIES:page_num*PAGE_STORIES]
    num_stories = prompt.story_set.exclude(draft=True).count()

    # Prompt's owner gets an edit link
    owner = ((profile is not None) and (profile == prompt.user))

    # Build context and render page
    context = { 'profile'       : profile,
                'prompt'        : prompt,
                'stories'       : stories,
                'owner'         : owner,
                'prompt_sidepanel' : 1,
                'page_url'      : u'/prompts/'+unicode(prompt.id)+u'/',
                'pages'         : bs_pager(page_num, PAGE_STORIES, num_stories),
            }

    return render(request, 'castle/prompt.html', context)

#-----------------------------------------------------------------------------
@login_required
@transaction.atomic
def submit_prompt(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get bits and bobs
    errors     = []
    prompt     = get_foo(request.POST, Prompt,  'prid')

    if (not profile.email_authenticated()):
        errors.append(u'You must have authenticated your e-mail address before posting a prompt');
    else:
        # Get prompt object, either existing or new
        new_prompt = False
        if (prompt is None):
            prompt = Prompt(user=profile)
            new_prompt = True

        # Populate prompt object with data from submitted form
        prompt.title  = request.POST.get('title', '')
        prompt.body   = request.POST.get('body', '')
        prompt.mature = request.POST.get('is_mature', False)
                
        # Check for submission errors
        if (len(prompt.title) < 1):
            errors.append(u'Prompt title must be at least 1 character long')
        
        l = len(prompt.body)
        if (l < 30):
            errors.append(u'Prompt body must be at least 30 characters long')
        
        if (l > 256):
            errors.append(u'Prompt is over 256 characters (currently ' + unicode(l) + u')')
    
    # If there have been errors, re-display the page
    if (errors):
    # Build context and render page
        context = { 'profile'       : profile,
                    'prompt'        : prompt,
                    'length_limit'  : 256,
                    'length_min'    : 30,
                    'user_dashboard': 1,
                    'error_title'   : 'Prompt submission unsuccessful',
                    'error_messages': errors,
                }

        return render(request, 'castle/edit_prompt.html', context)
    
    # Set modification time
    prompt.mtime = datetime.now()

    # No problems, update the database and redirect
    prompt.save()
    
    return HttpResponseRedirect(reverse('prompt', args=(prompt.id,)))

#-----------------------------------------------------------------------------
@login_required
def new_prompt(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Build context and render page
    context = { 'profile'       : profile,
                'story'         : Prompt(),      # Create blank story for default purposes
                'tags'          : u'',
                'length_limit'  : 256,
                'length_min'    : 30,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_prompt.html', context)

#-----------------------------------------------------------------------------
@login_required
def edit_prompt(request, prompt_id):
    # Get prompt
    prompt = get_object_or_404(Prompt, pk=prompt_id)
    
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # User can only edit their own stories
    if (prompt.user != profile):
        raise Http404
    
    # Build context and render page
    context = { 'profile'       : profile,
                'prompt'        : prompt,
                'length_limit'  : 1024,
                'length_min'    : 60,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_prompt.html', context)

#-----------------------------------------------------------------------------
# Blog views
#-----------------------------------------------------------------------------
def blogs(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Get blogs
    page_num = safe_int(request.GET.get('page_num', 1))
    blogs = Blog.objects.exclude(draft=True).order_by('ptime')[(page_num-1)*PAGE_BLOG:page_num*PAGE_BLOG]
    num_blogs = Blog.objects.exclude(draft = True).count()

    # Build context and render page
    context = { 'profile'       : profile,
                'blogs'         : blogs,
                'page_url'      : u'/blog/',
                'pages'         : bs_pager(1, 10, blogs.count()),
            }
    return render(request, 'castle/blogs.html', context)

#-----------------------------------------------------------------------------
def blog_view(request, blog_id, comment_text=None, error_title='', error_messages=None):
    blog = get_object_or_404(Blog, pk=blog_id)
    
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile

    # Is logged-in user the author?
    author = blog.user
    owner = ((profile is not None) and (profile == author))

    # Get comments
    page_num = safe_int(request.GET.get('page_num', 1))
    comments = blog.comment_set.all().order_by('ctime')[(page_num-1)*PAGE_COMMENTS:page_num*PAGE_COMMENTS]

    # Build context and render page
    context = { 'profile'       : profile,
                'author'        : blog.user,
                'blog'          : blog,
                'comments'      : comments,
                'page_url'      : u'/stories/'+unicode(blog_id),
                'pages'         : bs_pager(page_num, PAGE_COMMENTS, blog.comment_set.count()),
                'owner'         : owner,
                'comment_text'  : comment_text,
                'error_title'   : error_title,
                'error_messages': error_messages,
            }
    return render(request, 'castle/blog.html', context)

#-----------------------------------------------------------------------------
@login_required
def new_blog(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    if ((profile is None) or (not request.user.has_perm("castle.post_blog"))):
        raise Http404

    # Build context and render page
    context = { 'profile'       : profile,
                'blog'          : Blog(),      # Create blank blog for default purposes
                'length_limit'  : 20480,
                'length_min'    : 60,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_blog.html', context)

#-----------------------------------------------------------------------------
@login_required
def edit_blog(request, blog_id):
    # Get blog
    blog = get_object_or_404(Blog, pk=blog_id)

    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    if ((profile is None) or (not profile.has_perm("castle.post_blog"))):
        raise Http404

    # Build context and render page
    context = { 'profile'       : profile,
                'blog'          : blog,
                'length_limit'  : 20480,
                'length_min'    : 60,
                'user_dashboard': 1,
            }

    return render(request, 'castle/edit_blog.html', context)

#-----------------------------------------------------------------------------
@login_required
@transaction.atomic
def submit_blog(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    if ((profile is None) or (not profile.has_perm("castle.post_blog"))):
        raise Http404

    # Get bits and bobs
    errors     = []
    blog       = get_foo(request.POST, Blog,  'bid')
    new_blog   = (blog is None)
    was_draft  = False
    if (not new_blog):         # Remember if the blog was draft
        was_draft = blog.draft

    if (not profile.email_authenticated()):
        errors.append(u'You must have authenticated your e-mail address before posting a blog');
    else:
        # Get blog object, either existing or new
        if (blog is None):
            blog = Blog(user = profile)

        # Populate blog object with data from submitted form
        blog.title  = request.POST.get('title', '')
        blog.body   = request.POST.get('body', '')
        blog.draft  = request.POST.get('is_draft', False)
                
        # Check for submission errors
        if (len(blog.title) < 1):
            errors.append(u'Blog title must be at least 1 character long')
        
        l = len(blog.body)
        if ((not blog.draft) and (l < 60)):
            errors.append(u'Blog body must be at least 60 characters long')
        
        if (l > 20480):
            errors.append(u'Blog is over 20480 characters (currently ' + unicode(l) + u')')
    
    # If there have been errors, re-display the page
    if (errors):
    # Build context and render page
        context = { 'profile'       : profile,
                    'blog'          : blog,
                    'length_limit'  : 20480,
                    'length_min'    : 60,
                    'user_dashboard': 1,
                    'error_title'   : 'Blog submission unsuccessful',
                    'error_messages': errors,
                }

        return render(request, 'castle/edit_blog.html', context)

    # Is the blog being published?
    if (not draft and (was_draft or new_blog)):
        blog.ptime = datetime.now()
    
    # Set modification time
    blog.mtime = datetime.now()
    
    # No problems, update the database and redirect
    blog.save()
            
    return HttpResponseRedirect(reverse('blog', args=(blog.id,)))

#-----------------------------------------------------------------------------
@login_required
@transaction.atomic
def submit_comment(request):
    # Get user profile
    profile = None
    if (request.user.is_authenticated()):
        profile = request.user.profile
    
    # Get bits and bobs
    errors     = []
    blog       = get_foo(request.POST, Blog,  'bid')
    story      = get_foo(request.POST, Story, 'sid')
    rating     = request.POST.get('rating', None)
    if (rating is not None):
        rating = int(rating)

    if (not profile.email_authenticated()):
        errors.append(u'You must have authenticated your e-mail address before posting a comment');
    else:
        # Create comment object
        comment = Comment(user = profile,
                          blog = blog,
                          story = story)

        # Populate comment object with data from submitted form
        comment.body   = request.POST.get('body', '')

        # Check for submission errors
        l = len(comment.body)
        if ((l < 1) and (rating is None)):
            # Empty comments are allowed if the user is making a rating
            errors.append(u'Comment body must be at least 1 character long')
        
        if (l > 1024):
            errors.append(u'Comment is over 1024 characters (currently ' + unicode(l) + u')')

    # If there have been errors, re-display the page
    if (errors):
    # Build context and render page
        if (blog):
            return blog_view(request, blog.id, comment.body, 'Comment submission unsuccessful', errors)
        else:
            return story_view(request, story.id, comment.body, rating, u'Comment submission failed', errors)

    # Set modification time
    comment.mtime = datetime.now()
    
    # No problems, update the database and redirect
    if (l > 0):
        comment.save()
    
    # Update rating, if applicable
    if ((story is not None) and (rating is not None)):
        rating_set = Rating.objects.filter(story=story, user=profile)
        if (rating_set):
            rating_obj = rating_set[0]
        else:
            rating_obj = Rating(user=profile, story=story)
        rating_obj.rating = rating
        rating_obj.mtime = datetime.now()
        rating_obj.save()
            
    if (blog):
        return HttpResponseRedirect(reverse('blog', args=(blog.id,)))
    else:
        return HttpResponseRedirect(reverse('story', args=(story.id,)))
        

#-----------------------------------------------------------------------------
