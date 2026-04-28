from rest_framework.decorators import api_view,permission_classes,throttle_classes
from rest_framework.throttling import UserRateThrottle
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST,HTTP_200_OK,HTTP_500_INTERNAL_SERVER_ERROR
from .serializers import ModuleSerializer,CourseSerializer,NewCourseSerializer,NewModuleSerializer
from .models import Course,Module
import json

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
        path = 'courses-content/quizes/' if module.is_quiz else 'courses-content/lessons/'
        with open(path+str(module.filename)+'.json','r')as f:
            content = json.load(f)
            f.close()
    except Exception as e:
        print(e)
        return Response({'detail':'Internal Server Error'},status=HTTP_500_INTERNAL_SERVER_ERROR)
    data = {
        'module_id':module_id,
        'content':content
    }
    return Response(data,status=HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def add_course(request):
    if not request.user.is_superuser:
        return Response({'detail':'Invalid Request'},status=HTTP_400_BAD_REQUEST)
    try:
        course_serializer = NewCourseSerializer(data=request.data)
        if course_serializer.is_valid():
            course_name = course_serializer.validated_data['name']
            course_author = course_serializer.validated_data['author']
            if Course.objects.filter(name=course_name,author=course_author).exists():
                return Response({'detail':'Course already Exists'},status=HTTP_400_BAD_REQUEST)
            course_serializer.save()
            course = Course.objects.get(name=course_name,author=course_author)
            return Response({'detail':'Course Added','id':str(course.id)},status=HTTP_200_OK)
        else:
            return Response({'detail':'Invalid Request'},status=HTTP_400_BAD_REQUEST)
    except:
        return Response({'detail':'Internal Server Error'},status=HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def add_module(request):
    if not request.user.is_superuser:
        return Response({'detail':'Invalid Request'},status=HTTP_400_BAD_REQUEST)
    try:
        module_content = request.data['content']
        course_id = request.data['course_id']
        try:
            course = Course.objects.get(id=course_id)
        except:
            return Response({'detail':'Invalid Course ID'},status=HTTP_400_BAD_REQUEST)
        module_serializer = NewModuleSerializer(data=request.data)
        if module_serializer.is_valid():
            module_index = module_serializer.validated_data['index']
            module_isquiz = module_serializer.validated_data['is_quiz']
            if Module.objects.filter(course=course,index=module_index).exists():
                return Response({'detail':'Module at this index already Exists'},status=HTTP_400_BAD_REQUEST)
            module_serializer.save(course=course)
            module = Module.objects.get(course=course,index=module_index)
            file_dir = 'courses-content/quizes/' if module_isquiz else 'courses-content/lessons/'
            file_path = file_dir + str(module.filename) + '.json'
            with open(file_path,'w', encoding='utf-8') as f:
                json.dump(module_content, f)
                f.close()
            return Response({'detail':'Module Added'},status=HTTP_200_OK)
        else:
            return Response({'detail':'Invalid Request'},status=HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(e)
        return Response({'detail':'Internal Server Error'},status=HTTP_500_INTERNAL_SERVER_ERROR)
