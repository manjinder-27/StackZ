from django.db import models
from uuid import uuid4

class CategoryChoices(models.TextChoices):
    # Actual value stored in database | Human-readable name
    PROGRAMMING = 'PR', 'Programming Language' # Programming language like python,c 
    FRAMEWORK = 'FW', 'Framework' # frameworks like flutter,react
    DATABASE = 'DB', 'Database' # Databases like MySQL,PostgreSql
    OTHER = 'OT' , 'Other' # None of the above


class Course(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid4,
        editable=False
    )
    name = models.CharField(max_length=55)
    category = models.CharField(
        max_length=2,
        choices=CategoryChoices.choices,
        default=CategoryChoices.OTHER,
    )
    desc = models.TextField()


class Module(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid4,
        editable=False
    )
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    title = models.CharField(max_length=55)
    index = models.IntegerField()
    isQuiz = models.BooleanField()
    filename = models.CharField(max_length=55)