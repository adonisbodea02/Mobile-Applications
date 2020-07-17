from django.shortcuts import render
from rest_framework import generics
from .serializers import TShirtSerializer
from .models import TShirt


class TShirtsAPI(generics.ListCreateAPIView):
    serializer_class = TShirtSerializer
    queryset = TShirt.objects.all()


class TShirtAPI(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = TShirtSerializer

    def get_queryset(self):
        pk = self.kwargs.get('pk', None)
        return TShirt.objects.filter(pk=pk)
