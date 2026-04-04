from django.db import models
from django.contrib.auth.models import User

class UserProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE,editable=False)
    course_id = models.UUIDField(editable=False)
    module_index = models.IntegerField()
    completed_at = models.DateTimeField(auto_now=True)