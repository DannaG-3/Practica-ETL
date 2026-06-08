# Práctica 1: Proceso ETL

## 📋 Información Académica

| Campo         | Descripción                                                           |
| ------------- | --------------------------------------------------------------------- |
| **Materia**   | Análisis de Datos                                                     |
| **Actividad** | Práctica 1 - Proceso ETL                                              |
| **Profesor**  | Ing. Guillermo Quiñones Villareal                                     |
| **Equipo**    | N.° 9 - Danna Geraldine González Gaviño y Brayan Paul Pelayo Ascencio |

---

## 📊 Descripción del Proyecto

El presente proyecto implementa un proceso de preparación y validación de datos utilizando PostgreSQL como sistema gestor de bases de datos.

Como fuente de información se utilizó el dataset **Global Superstore Sales**, obtenido desde Kaggle y distribuido originalmente por Tableau con fines educativos. El objetivo principal consistió en cargar los datos originales, transformarlos a una estructura adecuada para análisis y verificar posteriormente la integridad y calidad de la información resultante.

Aunque la práctica se encuentra planteada bajo la metodología ETL (Extracción, Transformación y Carga), la fase final se orientó principalmente a la validación de los datos transformados mediante consultas SQL diseñadas para comprobar la consistencia de la información procesada.

---

## 📁 Estructura del Repositorio

```text
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
│   ├── Reporte.pdf
│   └── Evidencias.pdf
│
└── README.md
```

---

## 🗄️ Arquitectura de la Base de Datos

La solución fue diseñada utilizando dos esquemas principales:

### staging

Zona de recepción de datos.

Contiene la tabla:

```sql
staging.orders
```

Su propósito es almacenar el contenido original del archivo CSV sin modificaciones, permitiendo conservar una copia íntegra de los datos de origen.

### transformation

Zona de datos procesados.

Contiene las tablas:

```sql
transformation.datos_limpios
```

Tabla principal con la información transformada y preparada para análisis.

```sql
transformation.datos_cuarentena
```

Tabla destinada a almacenar registros que presenten inconsistencias o errores durante el proceso de transformación.

---

## 🔄 Flujo del Proceso

```text
SuperStoreOrders.csv
          │
          ▼
   staging.orders
          │
          ▼
 transformation.datos_limpios
          │
          ▼
transformation.datos_cuarentena
```

---

## 🚀 Ejecución del Proyecto

Los scripts deben ejecutarse en el orden indicado.

### Paso 1. Extracción

Ejecutar:

```text
01_extraccion.sql
```

Este script:

* Crea la base de datos de trabajo.
* Crea el esquema `staging`.
* Genera la tabla `staging.orders`.
* Carga el dataset mediante el comando `\copy`.

Resultado esperado:

* Base de datos creada.
* Esquema `staging` disponible.
* Tabla `orders` poblada con los datos originales.

---

### Paso 2. Transformación

Ejecutar:

```text
02_transformacion.sql
```

Este script:

* Lee los datos desde `staging.orders`.
* Estandariza formatos.
* Convierte tipos de datos.
* Genera las tablas del esquema `transformation`.
* Inserta los registros procesados.

Resultado esperado:

* Tabla `transformation.datos_limpios` creada y poblada.
* Tabla `transformation.datos_cuarentena` creada.

---

### Paso 3. Validación

Ejecutar:

```text
03_validacion.sql
```

Se recomienda ejecutar este archivo desde **Query Tool de pgAdmin** para facilitar la revisión individual de cada consulta.

Las validaciones incluyen:

* Existencia de tablas.
* Conteo de registros.
* Estructura de columnas.
* Valores nulos.
* Registros duplicados.
* Validación de fechas.
* Validación de campos numéricos.
* Verificación de la tabla de cuarentena.

Resultado esperado:

* Confirmación de la integridad de los datos transformados.
* Confirmación de la correcta estructura de la base de datos.
* Verificación de la calidad de los datos procesados.

---

## 📈 Dataset Utilizado

**Nombre:** Global Superstore Sales

**Origen:** Kaggle / Tableau

Características principales:

* Más de 51,000 registros.
* Información de órdenes comerciales.
* Datos de clientes y productos.
* Fechas de compra y envío.
* Ventas, descuentos y ganancias.
* Información geográfica y de mercado.

---

## ✅ Resultados Esperados

Al finalizar la ejecución de los tres scripts se deberá contar con:

* Base de datos PostgreSQL correctamente estructurada.
* Datos originales almacenados en el esquema `staging`.
* Datos transformados almacenados en el esquema `transformation`.
* Validaciones ejecutadas satisfactoriamente.
* Información preparada para análisis posteriores.

---

## 📚 Documentación Complementaria

La documentación completa del proyecto se encuentra en:

* Reporte escrito de la práctica.
* Documento de evidencias.
* Scripts SQL utilizados durante el proceso.

Estos documentos describen detalladamente el procedimiento realizado, las decisiones tomadas durante el desarrollo y los resultados obtenidos.
