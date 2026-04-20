from django.urls import path
from . import views

urlpatterns = [
    path('',views.list_courses,name="list_courses"),
    path('add/',views.add_course,name="add_course"),
    path('modules/add/',views.add_module,name="add_module"),
    path('modules/<str:module_id>/',views.get_module_data,name="get_module_data"),
    path('<str:course_id>/',views.get_course_data,name="get_course_data"),
    path('<str:course_id>/modules/',views.list_modules,name="list_modules"),
]