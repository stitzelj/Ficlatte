# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('castle', '0020_storylog_prompt'),
    ]

    operations = [
        migrations.AlterField(
            model_name='storylog',
            name='log_type',
            field=models.IntegerField(default=1, choices=[(0, 'wrote'), (1, 'viewed'), (2, 'rated'), (3, 'commented on'), (4, 'wrote a prequel to'), (5, 'wrote a sequel to'), (6, 'created challenge'), (7, 'updated story'), (8, 'wrote prompt'), (9, 'updated prompt')]),
            preserve_default=True,
        ),
    ]