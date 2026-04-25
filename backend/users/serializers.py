from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProgress

class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["first_name","last_name","username","email","password"]
        extra_kwargs = {
            "password":{"write_only":True,"min_length":8},
            "first_name":{"min_length":3},
            "last_name":{"min_length":3}
        }
    
    def create(self,data):
        user = User.objects.create_user(**data)
        return user


class UserProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='get_full_name')

    class Meta:
        model = User
        fields = ['username', 'full_name','email']

class ProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProgress
        fields = ['course_id','module_index','completed_at']
