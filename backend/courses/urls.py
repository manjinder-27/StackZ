from django.urls import path
from . import views

urlpatterns = [
    path('',views.list_courses,name="list_courses"),
    path('<str:course_id>/',views.get_course_data,name="get_course_data"),
    path('<str:course_id>/modules/',views.list_modules,name="list_modules"),
    path('modules/<str:module_id>/',views.get_module_data,name="get_module_data"),
]