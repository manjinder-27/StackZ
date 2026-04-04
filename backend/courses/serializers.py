from rest_framework import serializers
from .models import Module,Course

class ModuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Module
        fields = ['id','title','index']
        extra_kwargs = {
            'title':{'read_only':True},
            'index':{'read_only':True}
        }

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = ['id','name','category','desc']
        extra_kwargs = {
            'id':{'read_only':True},
            'name':{'read_only':True},
            'category':{'read_only':True}
        }