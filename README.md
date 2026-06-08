# Práctica 1: Proceso ETL

## 📋 Información Académica

| Campo | Descripción |
|-------|-------------|
| **Materia** | ANÁLISIS DE DATOS |
| **Actividad** | PRÁCTICA 1 - PROCESO ETL |
| **Profesor** | Ing. Guillermo Quiñones Villareal |
| **Equipo** | N°9 - Danna Geraldine González Gaviño y Brayan Paul Pelayo Ascencio |

---

## 📊 Descripción del Proyecto

El proyecto utiliza **PostgreSQL** para realizar las tres etapas principales del proceso **ETL** (Extracción, Transformación y Validación).

---

## 📁 Estructura del Repositorio

```
practica_etl/
│
├── datos/
│   └── SuperStoreOrders.csv
│
├── sql/
│   ├── 01_extraccion.sql
│   ├── 02_transformacion.sql
│   └── 03_validacion.sql
│
├── docs/
│   └── (pendiente)
│
└── README.md
```

---

## 🚀 Preparación Inicial

### Paso 1: Crear la base de datos
Ejecutar **01_extraccion.sql** para crear y llenar la base de datos.

### Paso 2: Conectarse a la base de datos
Los archivos SQL deben ejecutarse en orden secuencial, inicando por el anterior **01_extraccion.sql**, siguiendo con **02_transformacion.sql** y finalmente **03_validacion.sql**.