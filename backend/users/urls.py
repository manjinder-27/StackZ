from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from . import views

urlpatterns = [
    path('register/', views.register_user,name="register_user"),
    path('login/', views.login_user,name="login_user"),
    path('token/refresh/',TokenRefreshView.as_view(),name="refresh_user_token"),
    path('profile/',views.get_user_profile,name="get_user_profile"),
    path('progress/',views.update_progress,name="update_progress"),
    path('progress/<str:course_id>/',views.get_course_progress,name="get_course_progress")
]