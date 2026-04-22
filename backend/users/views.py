from django.contrib.auth import authenticate
from rest_framework.decorators import api_view,permission_classes,throttle_classes
from rest_framework.throttling import UserRateThrottle, AnonRateThrottle
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .serializers import RegisterSerializer,UserProfileSerializer,ProgressSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import AuthenticationFailed
from .models import UserProgress

def get_tokens_for_user(user):
    if not user.is_active:
      raise AuthenticationFailed("User is not active")

    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

@api_view(['POST'])
@throttle_classes([AnonRateThrottle,UserRateThrottle])
def register_user(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data,status=status.HTTP_201_CREATED)
    return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@throttle_classes([AnonRateThrottle,UserRateThrottle])
def login_user(request):
    try:
        username = request.data['username']
        password = request.data['password']
    except:
        return Response({'detail':"Invalid Request"},status=status.HTTP_400_BAD_REQUEST)
    user = authenticate(request,username=username,password=password)
    if user is None:
        return Response({"error":"Invalid User Credentials"},status=status.HTTP_401_UNAUTHORIZED)
    tokens = get_tokens_for_user(user)
    return Response(tokens,status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def get_user_profile(request):
    serializer = UserProfileSerializer(request.user)
    return Response(serializer.data,status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def update_progress(request):
    try:
        course_id = request.data['course_id']
        user = request.user
        module_completed_index = request.data['module_index']
        last_progress = UserProgress.objects.filter(user=user,course_id=course_id).first()
        if last_progress is None: #User has no progress yet
            if module_completed_index != 0: #But trying to update other than first module
                return Response({'detail':'Invalid/Tampered Request'},status=status.HTTP_400_BAD_REQUEST)
            else:
                progress = UserProgress(user=user,course_id=course_id,module_index=0)
                progress.save()
                return Response({'detail':'Progress Updated'},status=status.HTTP_204_NO_CONTENT)
        if last_progress.module_index != (module_completed_index - 1): #last module not completed
            return Response({'detail':'Invalid/Tampered Request'},status=status.HTTP_400_BAD_REQUEST)
        else:
            last_progress.module_index += 1
            last_progress.save()
            return Response({'detail':'Progress Updated'},status=status.HTTP_204_NO_CONTENT)
    except:
        return Response({'detail':'Invalid Request'},status=status.HTTP_400_BAD_REQUEST)



@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([UserRateThrottle])
def get_course_progress(request,course_id):
    try:
        user_progress = UserProgress.objects.get(user=request.user,course_id=course_id)
    except UserProgress.DoesNotExist:
        return Response({'detail':'No Progress data available'},status=status.HTTP_404_NOT_FOUND)
    except:
        return Response({'detail':'Invalid Request'},status=status.HTTP_400_BAD_REQUEST)
    serializer = ProgressSerializer(user_progress)
    return Response(serializer.data,status=status.HTTP_200_OK)