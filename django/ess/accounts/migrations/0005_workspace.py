# Generated by Django 4.0 on 2022-10-14 09:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0004_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='workspace',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('content', models.CharField(max_length=1000)),
                ('created_time', models.DateTimeField()),
            ],
        ),
    ]
