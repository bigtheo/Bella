from email.policy import default
from operator import mod
from statistics import mode
from tkinter import CASCADE
from turtle import pu
from unittest.util import _MAX_LENGTH
from django.db import models

class Users(models.Model):
    name = models.CharField(max_length=30)
    firstname = models.CharField(max_length=30)
    phone = models.CharField(max_length=30)
    photo = models.ImageField(max_length=30)
    login = models.CharField(max_length=30)
    password = models.CharField(max_length=30)


class message(models.Model):
    content= models.CharField(max_length=1000)
    created_time=models.DateTimeField()

class workspace(models.Model):
    content= models.CharField(max_length=1000)
    created_time=models.DateTimeField()

class entreprise :
    nom=models.CharField()
    
