from rest_framework.decorators import api_view,permission_classes,throttle_classes
from rest_framework.throttling import UserRateThrottle
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST,HTTP_200_OK,HTTP_500_INTERNAL_SERVER_ERROR
from .serializers import ModuleSerializer,CourseSerializer
from .models import Course,Module

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def get_course_data(request,course_id):
    try:
        course = Course.objects.get(id=course_id)
    except Course.DoesNotExist:
        return Response({'detail':'Invalid Course ID'},status=HTTP_400_BAD_REQUEST)
    return Response(CourseSerializer(course).data,status=HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def list_courses(request):
    courses = Course.objects.all()
    serializer = CourseSerializer(courses,many=True)
    return Response(serializer.data,status=HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def list_modules(request,course_id):
    try:
        course = Course.objects.get(id=course_id)
    except Course.DoesNotExist:
        return Response({'detail':'Invalid Course ID'},status=HTTP_400_BAD_REQUEST)
    modules = Module.objects.filter(course=course)
    serializer = ModuleSerializer(modules,many=True)
    return Response(serializer.data,status=HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def get_module_data(request,module_id):
    try:
        module = Module.objects.get(id=module_id)
    except Module.DoesNotExist:
        return Response({'detail':'Invalid Module ID'},status=HTTP_400_BAD_REQUEST)
    try:
        path = 'courses-content/quizes/' if module.isQuiz else 'courses-content/lessons/'
        with open(path+module.filename+'.json','r')as f:
            content = f.read()
            f.close()
    except:
        return Response({'detail':'Internal Server Error'},status=HTTP_500_INTERNAL_SERVER_ERROR)
    data = {
        'module_id':module_id,
        'content':content
    }
    return Response(data,status=HTTP_200_OK)