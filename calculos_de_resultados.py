import numpy as np
import scipy.stats as stats


# 1. DATOS RAW DEL GRUPO 1 (Condición Ciega - 30 sujetos x 26 ítems)
g1_raw = [
    ("Sí, acepto participar", "Grupo 1", [4.0, 4.0, 5.0, 4.0, 5.0, 3.0, 4.0, 2.0, 4.0, 4.0, 4.0, 5.0, 3.0, 3.0, 3.0, 4.0, 3.0, 3.0, 3.0, 2.0, 2.0, 3.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 3.0, 3.0, 3.0, 3.0, 2.0, 5.0, 3.0, 3.0, 3.0, 3.0, 5.0, 5.0, 5.0, 3.0, 5.0, 5.0, 3.0, 2.0, 5.0, 3.0, 3.0, 3.0, 3.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 5.0, 5.0, 4.0, 5.0, 3.0, 3.0, 5.0, 3.0, 5.0, 5.0, 4.0, 4.0, 4.0, 4.0, 5.0, 5.0, 2.0, 3.0, 4.0, 5.0, 3.0, 4.0, 4.0, 4.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 3.0, 4.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 3.0, 5.0, 5.0, 3.0, 4.0, 5.0, 5.0, 3.0, 5.0, 4.0, 4.0, 5.0, 4.0, 3.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [1.0, 1.0, 5.0, 5.0, 1.0, 1.0, 5.0, 1.0, 5.0, 1.0, 5.0, 5.0, 5.0, 1.0, 1.0, 5.0, 1.0, 5.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 4.0, 4.0, 5.0, 1.0, 1.0, 3.0, 4.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 5.0, 5.0, 5.0, 2.0, 4.0, 3.0, 3.0, 3.0, 3.0, 4.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 3.0, 2.0, 3.0, 5.0, 4.0, 2.0, 2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 4.0, 1.0, 1.0, 2.0, 1.0, 4.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 2.0, 4.0, 3.0, 3.0, 4.0, 5.0, 3.0, 3.0, 3.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 4.0, 5.0, 5.0, 5.0, 3.0, 3.0, 3.0, 5.0, 2.0, 4.0, 3.0, 3.0, 4.0, 3.0, 5.0, 3.0, 2.0, 1.0, 1.0, 2.0, 2.0, 2.0, 3.0, 2.0, 2.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 5.0, 5.0, 4.0, 5.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 3.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 5.0, 3.0, 4.0, 5.0, 4.0, 3.0, 4.0, 4.0, 4.0, 5.0, 4.0, 4.0, 3.0, 5.0, 3.0, 3.0, 5.0, 5.0, 4.0, 3.0, 4.0, 4.0, 4.0, 5.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 5.0, 3.0, 4.0, 4.0, 5.0, 3.0, 5.0, 3.0, 3.0, 4.0, 4.0, 3.0, 3.0, 4.0, 5.0, 4.0, 4.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 4.0, 5.0, 5.0, 2.0, 2.0, 3.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 3.0, 4.0, 3.0, 3.0, 4.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 5.0, 3.0, 3.0, 2.0, 3.0, 4.0, 3.0, 4.0, 3.0, 3.0, 4.0, 4.0, 5.0, 5.0, 5.0, 5.0, 3.0, 3.0, 4.0, 5.0, 5.0, 3.0, 5.0, 4.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 4.0, 5.0, 4.0, 4.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 3.0, 5.0, 4.0, 2.0, 2.0, 4.0, 4.0, 4.0, 3.0, 3.0, 4.0, 4.0, 3.0, 3.0, 4.0, 4.0, 3.0, 2.0, 2.0, 2.0, 3.0, 4.0, 2.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 2.0, 5.0, 4.0, 2.0, 3.0, 3.0, 2.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 5.0, 5.0, 4.0, 2.0, 2.0, 3.0, 3.0, 4.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 4.0, 5.0, 5.0, 5.0, 4.0, 5.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 4.0, 4.0, 4.0, 4.0, 5.0, 3.0, 5.0, 5.0, 5.0, 4.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 4.0, 5.0, 4.0, 2.0, 2.0, 4.0, 4.0, 4.0, 5.0, 3.0, 4.0, 3.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 5.0, 5.0, 4.0, 3.0, 2.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 3.0, 4.0, 5.0, 5.0, 4.0, 3.0, 2.0, 2.0, 3.0, 2.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 3.0, 2.0, 1.0, 1.0, 1.0, 3.0, 1.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 5.0, 4.0, 4.0, 2.0, 2.0, 4.0, 5.0, 5.0, 5.0, 2.0, 4.0, 1.0, 1.0, 2.0, 1.0, 1.0, 3.0, 2.0, 1.0, 1.0, 2.0, 1.0, 2.0, 5.0, 3.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 3.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 1.0, 1.0, 4.0, 3.0, 2.0, 2.0, 2.0, 1.0, 1.0, 3.0, 3.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 4.0, 5.0, 4.0, 3.0, 3.0, 1.0, 5.0, 5.0, 4.0, 3.0, 3.0, 3.0, 1.0, 3.0, 1.0, 1.0, 1.0, 1.0, 1.0, 5.0, 5.0, 3.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 1", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 1", [3.0, 5.0, 4.0, 4.0, 2.0, 4.0, 4.0, 4.0, 4.0, 3.0, 4.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 4.0, 4.0, 2.0, 4.0, 4.0, 3.0, 4.0, 5.0, 4.0]),
    ("Sí, acepto participar", "Grupo 1", [4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0])
]

# 2. DATOS RAW DEL GRUPO 2 (Condición Informada - Cadena continua parseada a 30 sujetos)
g2_raw = [
    ("Sí, acepto participar", "Grupo 2", [1.0, 2.0, 5.0, 3.0, 4.0, 1.0, 3.0, 2.0, 4.0, 1.0, 2.0, 4.0, 4.0, 4.0, 5.0, 4.0, 2.0, 2.0, 2.0, 3.0, 2.0, 4.0, 2.0, 3.0, 4.0, 4.0]),
    ("Sí, acepto participar", "Grupo 2", [3.0, 5.0, 4.0, 5.0, 3.0, 4.0, 2.0, 4.0, 3.0, 5.0, 4.0, 3.0, 4.0, 1.0, 1.0, 2.0, 2.0, 3.0, 1.0, 3.0, 1.0, 2.0, 3.0, 2.0, 2.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 4.0, 5.0, 1.0, 3.0, 3.0, 4.0, 2.0, 4.0, 4.0, 4.0, 2.0, 3.0, 2.0, 3.0, 1.0, 1.0, 2.0, 3.0, 2.0, 3.0, 1.0, 2.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 3.0, 4.0, 2.0, 2.0, 3.0, 4.0, 3.0, 4.0, 3.0, 5.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 3.0, 2.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 3.0, 4.0, 4.0, 4.0, 5.0, 5.0, 3.0, 5.0, 5.0, 5.0, 4.0, 4.0, 2.0, 5.0, 4.0, 4.0, 5.0, 5.0, 3.0, 2.0, 2.0, 3.0, 4.0, 3.0, 4.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 5.0, 1.0, 1.0, 2.0, 5.0, 3.0, 3.0, 3.0, 3.0, 3.0, 5.0, 5.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 3.0, 4.0, 4.0, 4.0, 2.0, 3.0, 5.0, 5.0, 4.0, 3.0, 1.0, 5.0, 3.0, 4.0, 2.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 4.0, 5.0, 4.0, 5.0, 3.0, 3.0, 3.0, 5.0, 5.0, 5.0, 4.0, 4.0, 2.0, 5.0, 5.0, 3.0, 4.0, 4.0, 1.0, 3.0, 4.0, 4.0, 3.0, 1.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 3.0, 4.0, 5.0, 3.0, 1.0, 1.0, 3.0, 3.0, 3.0, 3.0, 2.0, 2.0, 2.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 4.0, 5.0, 5.0, 4.0, 5.0, 5.0, 3.0, 5.0, 5.0, 3.0, 4.0, 5.0, 5.0, 4.0, 4.0, 4.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 4.0, 4.0, 5.0]),
    ("Sí, acepto participar", "Grupo 2", [2.0, 4.0, 5.0, 4.0, 1.0, 1.0, 5.0, 3.0, 4.0, 2.0, 4.0, 4.0, 4.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 4.0, 2.0, 3.0, 2.0, 5.0, 1.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 3.0, 3.0, 4.0, 5.0, 5.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [3.0, 3.0, 4.0, 4.0, 3.0, 2.0, 5.0, 2.0, 4.0, 4.0, 4.0, 4.0, 4.0, 2.0, 4.0, 3.0, 3.0, 3.0, 3.0, 4.0, 2.0, 3.0, 4.0, 4.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 3.0, 5.0, 4.0, 3.0, 3.0, 3.0, 4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 4.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 4.0, 4.0, 3.0, 4.0, 3.0, 3.0, 4.0, 5.0, 4.0, 3.0, 4.0, 3.0, 3.0, 4.0, 3.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [3.0, 4.0, 2.0, 5.0, 1.0, 3.0, 2.0, 4.0, 3.0, 3.0, 3.0, 4.0, 4.0, 3.0, 3.0, 4.0, 3.0, 1.0, 1.0, 2.0, 1.0, 3.0, 3.0, 1.0, 4.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [2.0, 1.0, 3.0, 2.0, 3.0, 2.0, 5.0, 4.0, 3.0, 5.0, 4.0, 5.0, 4.0, 1.0, 1.0, 2.0, 2.0, 3.0, 2.0, 1.0, 1.0, 4.0, 5.0, 2.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [3.0, 4.0, 5.0, 5.0, 4.0, 2.0, 4.0, 4.0, 3.0, 3.0, 4.0, 4.0, 4.0, 2.0, 1.0, 4.0, 4.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 4.0, 3.0, 5.0, 5.0, 3.0, 5.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 4.0, 4.0, 4.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 2.0, 5.0, 5.0, 5.0, 3.0, 2.0, 4.0, 3.0, 3.0, 2.0, 3.0, 3.0, 3.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 2.0, 5.0, 5.0, 5.0, 3.0, 2.0, 4.0, 1.0, 4.0, 5.0, 3.0, 2.0, 4.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 3.0, 5.0, 4.0, 5.0, 4.0, 3.0, 2.0, 4.0, 2.0, 5.0, 4.0, 3.0, 2.0, 4.0, 4.0, 2.0, 4.0, 4.0, 2.0, 1.0, 3.0, 2.0, 2.0, 2.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [1.0, 5.0, 5.0, 3.0, 1.0, 1.0, 5.0, 1.0, 5.0, 5.0, 3.0, 5.0, 5.0, 1.0, 1.0, 3.0, 1.0, 1.0, 1.0, 5.0, 1.0, 5.0, 5.0, 3.0, 4.0, 5.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 3.0, 4.0, 4.0, 4.0, 2.0, 4.0, 2.0, 2.0, 4.0, 3.0, 3.0, 3.0, 2.0]),
    ("Sí, acepto participar", "Grupo 2", [5.0, 4.0, 5.0, 5.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 5.0, 5.0, 4.0, 3.0, 4.0, 2.0, 4.0, 3.0, 5.0, 3.0, 1.0, 2.0]),
    ("Sí, acepto participar", "Grupo 2", [3.0, 3.0, 4.0, 2.0, 2.0, 2.0, 5.0, 3.0, 4.0, 3.0, 4.0, 5.0, 5.0, 2.0, 3.0, 3.0, 2.0, 3.0, 2.0, 2.0, 2.0, 2.0, 3.0, 1.0, 1.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 4.0, 4.0, 5.0, 5.0, 5.0, 4.0, 2.0, 5.0, 5.0, 2.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0]),
    ("Sí, acepto participar", "Grupo 2", [4.0, 4.0, 3.0, 2.0, 5.0, 3.0, 3.0, 5.0, 3.0, 4.0, 2.0, 5.0, 4.0, 1.0, 1.0, 1.0, 1.0, 4.0, 3.0, 4.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
]

# =====================================================================
# 1. VALIDACIÓN DE LOS DATOS
# =====================================================================

print("\n" + "=" * 65)
print("1. VALIDACIÓN DE DATOS")
print("=" * 65)

# Comprobar cantidad de participantes
assert len(g1_raw) == 30, (
    f"Grupo 1: se esperaban 30 participantes, "
    f"se encontraron {len(g1_raw)}"
)

assert len(g2_raw) == 30, (
    f"Grupo 2: se esperaban 30 participantes, "
    f"se encontraron {len(g2_raw)}"
)

# Comprobar cantidad de respuestas por participante
for i, (_, _, vals) in enumerate(g1_raw):
    assert len(vals) == 26, (
        f"Error en Grupo 1, participante {i+1}: "
        f"tiene {len(vals)} respuestas"
    )

for i, (_, _, vals) in enumerate(g2_raw):
    assert len(vals) == 26, (
        f"Error en Grupo 2, participante {i+1}: "
        f"tiene {len(vals)} respuestas"
    )

# Comprobar rango de respuestas Likert
for grupo_nombre, grupo in [
    ("Grupo 1", g1_raw),
    ("Grupo 2", g2_raw)
]:
    for i, (_, _, vals) in enumerate(grupo):
        assert all(1 <= v <= 5 for v in vals), (
            f"Respuesta fuera de rango en {grupo_nombre}, "
            f"participante {i+1}"
        )

print("Grupo 1: 30 participantes, 26 respuestas por participante.")
print("Grupo 2: 30 participantes, 26 respuestas por participante.")
print("Todas las respuestas están dentro del rango Likert 1-5.")
print("VALIDACIÓN COMPLETADA CORRECTAMENTE.")


# =====================================================================
# 2. PROCESAMIENTO Y EXTRACCIÓN DE VARIABLES
# =====================================================================

print("\n" + "=" * 65)
print("2. EXTRACCIÓN DE VARIABLES")
print("=" * 65)

# GRUPO 1 - CONDICIÓN CIEGA

g1_tradicional = np.array([
    np.mean(vals[:13])
    for _, _, vals in g1_raw
])

g1_ia = np.array([
    np.mean(vals[13:])
    for _, _, vals in g1_raw
])

g1_actitud = np.array([
    vals[0]
    for _, _, vals in g1_raw
])


# GRUPO 2 - CONDICIÓN INFORMADA

g2_tradicional = np.array([
    np.mean(vals[:13])
    for _, _, vals in g2_raw
])

g2_ia = np.array([
    np.mean(vals[13:])
    for _, _, vals in g2_raw
])

g2_actitud = np.array([
    vals[0]
    for _, _, vals in g2_raw
])


print("Variables extraídas correctamente.")
print(f"Participantes Grupo 1: {len(g1_tradicional)}")
print(f"Participantes Grupo 2: {len(g2_tradicional)}")


# =====================================================================
# 3. ESTADÍSTICOS DESCRIPTIVOS
# =====================================================================

print("\n" + "=" * 65)
print("3. ESTADÍSTICOS DESCRIPTIVOS")
print("=" * 65)

def mostrar_descriptivos(nombre, datos):

    print(f"\n{nombre}")
    print(f"Media:             {np.mean(datos):.3f}")
    print(f"Desviación estándar: {np.std(datos, ddof=1):.3f}")
    print(f"Mínimo:            {np.min(datos):.3f}")
    print(f"Máximo:            {np.max(datos):.3f}")


mostrar_descriptivos("Grupo 1 - Tradicional", g1_tradicional)
mostrar_descriptivos("Grupo 1 - IA", g1_ia)

mostrar_descriptivos("Grupo 2 - Tradicional", g2_tradicional)
mostrar_descriptivos("Grupo 2 - IA", g2_ia)


# =====================================================================
# 4. PRUEBAS T EMPAREJADAS
# =====================================================================

print("\n" + "=" * 65)
print("4. PRUEBAS T EMPAREJADAS")
print("=" * 65)

# Grupo 1
t_g1, p_g1 = stats.ttest_rel(
    g1_tradicional,
    g1_ia
)

print("\nGrupo 1 (Condición Ciega)")
print(f"t = {t_g1:.4f}")
print(f"p = {p_g1:.6f}")

# Grupo 2
t_g2, p_g2 = stats.ttest_rel(
    g2_tradicional,
    g2_ia
)

print("\nGrupo 2 (Condición Informada)")
print(f"t = {t_g2:.4f}")
print(f"p = {p_g2:.6f}")


# =====================================================================
# 5. CÁLCULO DE CAÍDAS INDIVIDUALES
# =====================================================================

print("\n" + "=" * 65)
print("5. COMPARACIÓN DE CAÍDAS ENTRE GRUPOS")
print("=" * 65)

# Caída = Evaluación tradicional - Evaluación IA

caida_g1 = g1_tradicional - g1_ia
caida_g2 = g2_tradicional - g2_ia

# Resultados descriptivos
mostrar_descriptivos("Caídas - Grupo 1", caida_g1)
mostrar_descriptivos("Caídas - Grupo 2", caida_g2)

# Diferencia entre las caídas medias
diferencia_caidas = np.mean(caida_g1) - np.mean(caida_g2)

print("\nDiferencia entre caídas medias:")
print(f"{diferencia_caidas:.4f}")


# =====================================================================
# 6. PRUEBA T INDEPENDIENTE DE WELCH
# =====================================================================

print("\n" + "=" * 65)
print("6. PRUEBA T INDEPENDIENTE (WELCH)")
print("=" * 65)

t_ind, p_ind = stats.ttest_ind(
    caida_g1,
    caida_g2,
    equal_var=False
)

# Grados de libertad aproximados de Welch
n1 = len(caida_g1)
n2 = len(caida_g2)

s1 = np.var(caida_g1, ddof=1)
s2 = np.var(caida_g2, ddof=1)

numerador = (s1/n1 + s2/n2)**2

denominador = (
    (s1/n1)**2 / (n1-1)
    +
    (s2/n2)**2 / (n2-1)
)

gl_welch = numerador / denominador

print(f"Caída media Grupo 1: {np.mean(caida_g1):.4f}")
print(f"Caída media Grupo 2: {np.mean(caida_g2):.4f}")

print(f"\nt = {t_ind:.4f}")
print(f"Grados de libertad = {gl_welch:.2f}")
print(f"p = {p_ind:.6f}")


# =====================================================================
# 7. CORRELACIONES DE PEARSON
# =====================================================================

print("\n" + "=" * 65)
print("7. CORRELACIONES DE PEARSON")
print("=" * 65)

# Grupo 1:
# Actitud inicial vs evaluación IA

r_g1, p_r_g1 = stats.pearsonr(
    g1_actitud,
    g1_ia
)

print("\nGrupo 1: Actitud inicial vs. IEJ IA")
print(f"r = {r_g1:.4f}")
print(f"p = {p_r_g1:.6f}")


# Grupo 2:
# Actitud inicial vs brecha de valoración

brecha_g2 = g2_tradicional - g2_ia

r_g2, p_r_g2 = stats.pearsonr(
    g2_actitud,
    brecha_g2
)

print("\nGrupo 2: Actitud inicial vs. Brecha de valoración")
print(f"r = {r_g2:.4f}")
print(f"p = {p_r_g2:.6f}")


# =====================================================================
# 8. RESULTADOS INDIVIDUALES DE LOS 60 PARTICIPANTES
# =====================================================================

print("\n" + "=" * 65)
print("8. RESULTADOS INDIVIDUALES")
print("=" * 65)

print("\nGRUPO 1 - CONDICIÓN CIEGA")

print(
    f"{'Sujeto':<10}"
    f"{'Tradicional':<15}"
    f"{'IA':<15}"
    f"{'Caída':<15}"
)

for i in range(30):
    print(
        f"{i+1:<10}"
        f"{g1_tradicional[i]:<15.2f}"
        f"{g1_ia[i]:<15.2f}"
        f"{caida_g1[i]:<15.2f}"
    )


print("\nGRUPO 2 - CONDICIÓN INFORMADA")

print(
    f"{'Sujeto':<10}"
    f"{'Tradicional':<15}"
    f"{'IA':<15}"
    f"{'Caída':<15}"
)

for i in range(30):
    print(
        f"{i+1:<10}"
        f"{g2_tradicional[i]:<15.2f}"
        f"{g2_ia[i]:<15.2f}"
        f"{caida_g2[i]:<15.2f}"
    )


# =====================================================================
# 9. RESUMEN FINAL DE RESULTADOS
# =====================================================================

print("\n" + "=" * 65)
print("9. RESUMEN FINAL DEL ANÁLISIS")
print("=" * 65)

print("\nPRUEBAS T EMPAREJADAS")
print(f"Grupo 1: t = {t_g1:.4f}, p = {p_g1:.6f}")
print(f"Grupo 2: t = {t_g2:.4f}, p = {p_g2:.6f}")

print("\nCOMPARACIÓN DE CAÍDAS")
print(f"Grupo 1: {np.mean(caida_g1):.4f}")
print(f"Grupo 2: {np.mean(caida_g2):.4f}")
print(f"Diferencia: {diferencia_caidas:.4f}")
print(
    f"Welch: t = {t_ind:.4f}, "
    f"gl = {gl_welch:.2f}, p = {p_ind:.6f}"
)

print("\nCORRELACIONES")
print(f"Grupo 1: r = {r_g1:.4f}, p = {p_r_g1:.6f}")
print(f"Grupo 2: r = {r_g2:.4f}, p = {p_r_g2:.6f}")

print("\n" + "=" * 65)
print("ANÁLISIS ESTADÍSTICO COMPLETADO")
print("=" * 65)
