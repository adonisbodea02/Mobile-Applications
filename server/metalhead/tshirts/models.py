from django.db import models


class TShirt(models.Model):
    band = models.CharField(max_length=255)
    color = models.CharField(max_length=255)
    size = models.CharField(max_length=255)
    price = models.IntegerField()
    currency = models.CharField(max_length=255)
