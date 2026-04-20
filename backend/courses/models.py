from django.db import models
from uuid import uuid4

class Course(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid4,
        editable=False
    )
    name = models.CharField(max_length=55)
    desc = models.TextField()
    author = models.CharField(max_length=55)


class Module(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid4,
        editable=False
    )
    course = models.ForeignKey(Course, on_delete=models.CASCADE,editable=False)
    title = models.CharField(max_length=55)
    index = models.IntegerField()
    is_quiz = models.BooleanField()
    filename = models.UUIDField(default=uuid4,editable=False)