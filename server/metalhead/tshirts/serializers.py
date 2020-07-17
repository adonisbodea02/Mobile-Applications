from rest_framework import serializers
from .models import TShirt


class TShirtSerializer(serializers.ModelSerializer):
    class Meta:
        model = TShirt
        fields = ['band', 'color', 'size', 'price', 'currency', 'id']
