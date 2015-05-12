from django.core.management.base import BaseCommand, CommandError
from castle.models import *
from django.db import transaction, connection
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist

class Command(BaseCommand):
    help = 'Import old Ficlatte database into Django database'
    args =''
    
    @transaction.atomic
    def do_nightly(self):
        db = getattr(settings, 'DB', 'mysql')

        # Zero out all activity values
        Story.objects.all().update(activity=0)
        
        cursor = connection.cursor()
        
        if (db == 'mysql'):
            cursor.execute(
                "UPDATE castle_story AS s SET activity = (SELECT "+
                "sum(l.log_type / (timestampdiff(day,l.ctime,now())+1)) "+
                "FROM castle_storylog AS l "+
                "WHERE l.story_id IS NOT NULL AND s.id=l.story_id "+
                "AND ((timestampdiff(day,l.ctime,now())) < 30) "+
                "AND l.user_id != s.user_id )")
        elif (db == 'postgres'):
            cursor.execute(
                "UPDATE castle_story AS s SET activity = (SELECT "+
                "sum(l.log_type / (date_part('day', NOW() - l.ctime)+1)) "+
                "FROM castle_storylog AS l "+
                "WHERE l.story_id IS NOT NULL AND s.id=l.story_id "+
                "AND ((date_part('day', NOW() - l.ctime)) < 30) "+
                "AND l.user_id != s.user_id )")

        # Find most active story
        ma = Story.objects.filter(activity__isnull = False).order_by('-activity')[0:1]
        if (ma and (ma[0])):
            # Find 'featured' object in Misc table and update with new most-active story
            ff = Misc.objects.filter(key='featured')
            if (ff):
                f = ff[0]
            else:
                f = Misc(key='featured')
            
            f.i_val = ma[0].id
            f.save()

        return None

            
    def handle(self, *args, **options):
        self.do_nightly()
        