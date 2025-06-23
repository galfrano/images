USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarEstados]    Script Date: 6/23/2025 8:53:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure para gestionar Estados
ALTER PROCEDURE [dbo].[spGestionarEstados]
    @Modo INT, -- Valor que representa la operación a realizar (1 = CREATE, 2 = READ, 3 = UPDATE, 4 = DELETE)
    @EstadosID INT = NULL,
    @NombreEstado NVARCHAR(100) = NULL
AS
BEGIN
    IF @Modo = 1  -- CREATE
    BEGIN
        INSERT INTO Estados (NombreEstado)
        VALUES (@NombreEstado);

		-- Obtener el último ID insertado
        SELECT SCOPE_IDENTITY() AS ID;
    END;

    IF @Modo = 2  -- READ
    BEGIN
        SELECT * FROM Estados WHERE EstadosID = @EstadosID;
    END;

    IF @Modo = 3  -- UPDATE
    BEGIN
        UPDATE Estados
        SET NombreEstado = @NombreEstado
        WHERE EstadosID = @EstadosID;
    END;

    IF @Modo = 4  -- DELETE
    BEGIN
        DELETE FROM Estados WHERE EstadosID = @EstadosID;
    END;

	IF @Modo = 5 -- Combo
	BEGIN
		SELECT EstadosID AS Id,
			   NombreEstado AS Valor
		  FROM Estados;
	END;
END;



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarInforme]    Script Date: 6/23/2025 8:57:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spGestionarInforme]
  -- Add the parameters for the stored procedure here	
  @Modo INT,
  @InformeID INT
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  -- Insert statements for procedure here
  IF @Modo = 1 -- Vehiculo
  BEGIN
    SELECT *
      FROM dbo.Vehiculos AS v
     WHERE v.InformeID = @InformeID
  END
  ELSE
  IF @Modo = 2 -- Robo
  BEGIN
    SELECT *
      FROM dbo.ReporteRobo AS rr
     WHERE rr.InformeID = @InformeID;
  END
  ELSE
  IF @Modo = 3 -- Tenencias
  BEGIN
    /*SELECT *
      FROM dbo.Tenencias t
     WHERE t.InformeID = @InformeID;*/
	 SELECT      ISNULL(t.ejercicio, YEAR(GETDATE())) AS ejercicio,
            ISNULL(t.refrendo, 0) AS refrendo,
            ISNULL(t.tenencia, 0) AS tenencia,
            ISNULL(t.total, 0) AS total,
            ISNULL(t.lineacaptura, 'Sin información') AS lineacaptura,
            ISNULL(t.vigencia, 'Sin información') AS vigencia,
            ISNULL(t.dagid, '') AS dagid,
            ISNULL(t.lineacapturaCB, 'Sin información') AS lineacapturaCB,
            si.InformeID AS InformeID,
            ISNULL(t.UsuarioID, si.UsuarioID) AS UsuarioID,
            ISNULL(t.FechaUltimaModificacion, GETDATE()) AS FechaUltimaModificacion
  FROM      dbo.SolicitudInformes AS si
  LEFT JOIN dbo.Tenencias AS t
    ON t.InformeID = si.InformeID
 WHERE      si.InformeID = @InformeID;
  END
  ELSE
  IF @Modo = 4 -- Semaforo Vehiculo
  BEGIN
    SELECT COUNT(t.InformeID) AS eTenencias,
           COUNT(rr.InformeID) AS eReporteRobo,
           COUNT(i.InformeID) AS eInfracciones,
           COUNT(vd.InformeID) AS eValuacion_Danios
      FROM dbo.Vehiculos AS v
      LEFT JOIN dbo.Tenencias AS t
        ON t.InformeID = v.InformeID
      LEFT JOIN dbo.ReporteRobo AS rr
        ON rr.InformeID = v.InformeID
       AND LEN(rr.fecha_robo) > 0
      LEFT JOIN dbo.Infracciones AS i
        ON i.InformeID = v.InformeID
      LEFT JOIN dbo.Valuacion_Danios AS vd
        ON vd.InformeID = v.InformeID
     WHERE v.InformeID = @InformeID;
  END
  ELSE
  IF @Modo = 5 -- Tenencias
  BEGIN
    SELECT *
      FROM dbo.Infracciones AS i
     WHERE i.InformeID = @InformeID
  END
  ELSE
  IF @Modo = 6 -- Tenencias
  BEGIN
    SELECT *
      FROM dbo.Valuacion_Danios AS vd
     WHERE vd.InformeID = @InformeID
  END
END




USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarInformeTipo]    Script Date: 6/23/2025 9:03:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure para gestionar Tipos de Informe
ALTER PROCEDURE [dbo].[spGestionarInformeTipo]
    @Modo INT, -- Valor que representa la operación a realizar (1 = CREATE, 2 = READ, 3 = UPDATE, 4 = DELETE, 5 = COMBO)
    @InformeTipoID INT = NULL,
    @Nombre NVARCHAR(MAX) = NULL,
    @Precio DECIMAL(18, 4) = NULL,
    @Activo BIT = NULL,
    @FechaCreacion DATETIME = NULL,
    @FechaUltimaModificacion DATETIME = NULL,
    @UsuarioModificacionID INT = NULL
AS
BEGIN
    IF @Modo = 1  -- CREATE
    BEGIN
        INSERT INTO InformeTipos (Nombre, Precio, Activo, FechaCreacion, FechaUltimaModificacion, UsuarioModificacionID)
        VALUES (@Nombre, @Precio, @Activo, GETDATE(), GETDATE(), @UsuarioModificacionID);

        -- Obtener el último ID insertado
        SELECT SCOPE_IDENTITY() AS ID;
    END;

    IF @Modo = 2  -- READ
    BEGIN
        SELECT * FROM InformeTipos WHERE InformeTipoID = @InformeTipoID;
    END;

    IF @Modo = 3  -- UPDATE
    BEGIN
        UPDATE InformeTipos
        SET Nombre = @Nombre,
            Precio = @Precio,
            Activo = @Activo,
            FechaUltimaModificacion = GETDATE(),
            UsuarioModificacionID = @UsuarioModificacionID
        WHERE InformeTipoID = @InformeTipoID;
    END;

    IF @Modo = 4  -- DELETE
    BEGIN
        DELETE FROM InformeTipos WHERE InformeTipoID = @InformeTipoID;
    END;

    IF @Modo = 5 -- Combo
    BEGIN
        SELECT InformeTipoID AS Id,
               Nombre AS Valor
        FROM InformeTipos;
    END;
END;



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarInfracciones]    Script Date: 6/23/2025 9:04:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGestionarInfracciones]
    @Modo INT,
    @folio VARCHAR(MAX) = NULL,
    @fecha DATETIME = NULL,
    @situacion VARCHAR(MAX) = NULL,
    @motivo VARCHAR(MAX) = NULL,
    @fundamento VARCHAR(MAX) = NULL,
    @sancion VARCHAR(MAX) = NULL,
    @descripcion VARCHAR(MAX) = NULL,
    @importe FLOAT = NULL,
    @linea_captura VARCHAR(MAX) = NULL,
    @vigencia VARCHAR(MAX) = NULL,
    @unid VARCHAR(MAX) = NULL,
    @InformeID INT = NULL,
    @UsuarioID INT = NULL,
    @FechaUltimaModificacion DATETIME = NULL
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.Infracciones (
            folio, fecha, situacion, motivo, fundamento, sancion, descripcion, importe,
            linea_captura, vigencia, unid, InformeID, UsuarioID, FechaUltimaModificacion
        )
        VALUES (
            @folio, @fecha, @situacion, @motivo, @fundamento, @sancion, @descripcion, @importe,
            @linea_captura, @vigencia, @unid, @InformeID, @UsuarioID, @FechaUltimaModificacion
        )
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.Infracciones
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de búsqueda
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.Infracciones
        SET folio = @folio,
            fecha = @fecha,
            situacion = @situacion,
            motivo = @motivo,
            fundamento = @fundamento,
            sancion = @sancion,
            descripcion = @descripcion,
            importe = @importe,
            linea_captura = @linea_captura,
            vigencia = @vigencia,
            unid = @unid,
            InformeID = @InformeID,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.Infracciones
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END
END



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarPaises]    Script Date: 6/23/2025 9:04:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure para gestionar Países
ALTER PROCEDURE [dbo].[spGestionarPaises]
    @Modo INT, -- Valor que representa la operación a realizar (1 = CREATE, 2 = READ, 3 = UPDATE, 4 = DELETE)
    @PaisID INT = NULL,
    @Nombre VARCHAR(255) = NULL
AS
BEGIN
    IF @Modo = 1  -- CREATE
    BEGIN
        INSERT INTO Paises (Nombre)
        VALUES (@Nombre);

		-- Obtener el último ID insertado
        SELECT SCOPE_IDENTITY() AS ID;
    END;

    IF @Modo = 2  -- READ
    BEGIN
        SELECT * FROM Paises WHERE PaisID = @PaisID;
    END;

    IF @Modo = 3  -- UPDATE
    BEGIN
        UPDATE Paises
        SET Nombre = @Nombre
        WHERE PaisID = @PaisID;
    END;

    IF @Modo = 4  -- DELETE
    BEGIN
        DELETE FROM Paises WHERE PaisID = @PaisID;
    END;

	IF @Modo = 5 -- Combo
	BEGIN
		SELECT PaisID AS Id,
			   Nombre AS Valor
		  FROM Paises;
	END;
END;


USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarReporteRobo]    Script Date: 6/23/2025 9:05:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGestionarReporteRobo]
(
    @Modo INT,
    @Sistema NVARCHAR(MAX) = NULL,
    @Reporte NVARCHAR(MAX) = NULL,
    @Status NVARCHAR(MAX) = NULL,
    @Entidad NVARCHAR(MAX) = NULL,
    @FechaActualizacion NVARCHAR(MAX) = NULL,
    @FechaRobo NVARCHAR(MAX) = NULL,
    @FechaAveriguacion NVARCHAR(MAX) = NULL,
    @EntidadRecuperacion NVARCHAR(MAX) = NULL,
    @FechaRecuperacion NVARCHAR(MAX) = NULL,
    @Descripcion NVARCHAR(MAX) = NULL,
	@InformeID INT = NULL,
    @UsuarioID INT = NULL,
    @FechaUltimaModificacion DATETIME = NULL
)
AS
BEGIN
    IF @Modo = 1 -- Insertar
    BEGIN
        INSERT INTO dbo.ReporteRobo
        (
            [sistema],
            [reporte],
            [status],
            [entidad],
            [fecha_actualizacion],
            [fecha_robo],
            [fecha_averiguacion],
            [entidad_recuperacion],
            [fecha_recuperacion],
            [descripcion],
            [UsuarioID],
            [FechaUltimaModificacion],
			InformeID
        )
        VALUES
        (
            @Sistema,
            @Reporte,
            @Status,
            @Entidad,
            @FechaActualizacion,
            @FechaRobo,
            @FechaAveriguacion,
            @EntidadRecuperacion,
            @FechaRecuperacion,
            @Descripcion,
            @UsuarioID,
            @FechaUltimaModificacion,
			@InformeID
        );
    END
	ELSE IF @Modo = 2 -- Consultar por Reporte
    BEGIN
        SELECT
            *
        FROM dbo.ReporteRobo
        WHERE InformeID = @InformeID;
    END    
    ELSE IF @Modo = 3 -- Actualizar
    BEGIN
        UPDATE dbo.ReporteRobo
        SET
            [sistema] = @Sistema,
            [status] = @Status,
            [entidad] = @Entidad,
            [fecha_actualizacion] = @FechaActualizacion,
            [fecha_robo] = @FechaRobo,
            [fecha_averiguacion] = @FechaAveriguacion,
            [entidad_recuperacion] = @EntidadRecuperacion,
            [fecha_recuperacion] = @FechaRecuperacion,
            [descripcion] = @Descripcion,
            [UsuarioID] = @UsuarioID,
            [FechaUltimaModificacion] = @FechaUltimaModificacion
        WHERE InformeID = @InformeID;
    END
    ELSE IF @Modo = 4 -- Eliminar
    BEGIN
        DELETE FROM dbo.ReporteRobo
        WHERE [reporte] = @Reporte;
    END    
END;



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarSeguros]    Script Date: 6/23/2025 9:05:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spGestionarSeguros]
    @Modo INT,
    @poliza VARCHAR(20) = NULL,
    @marca VARCHAR(50) = NULL,
    @anio_modelo INT = NULL,
    @submarca VARCHAR(50) = NULL,
    @inciso VARCHAR(50) = NULL,
    @fin_vigencia DATE = NULL,
    @inicio_vigencia DATE = NULL,
    @InformeID INT = NULL,
    @UsuarioID INT,
    @FechaUltimaModificacion DATETIME
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.Seguros (
            poliza, marca, anio_modelo, submarca, inciso, fin_vigencia, inicio_vigencia,
            InformeID, UsuarioID, FechaUltimaModificacion
        )
        VALUES (
            @poliza, @marca, @anio_modelo, @submarca, @inciso, @fin_vigencia, @inicio_vigencia,
            @InformeID, @UsuarioID, @FechaUltimaModificacion
        )
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.Seguros
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de búsqueda
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.Seguros
        SET poliza = @poliza,
            marca = @marca,
            anio_modelo = @anio_modelo,
            submarca = @submarca,
            inciso = @inciso,
            fin_vigencia = @fin_vigencia,
            inicio_vigencia = @inicio_vigencia,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.Seguros
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END
END


USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarSexo]    Script Date: 6/23/2025 9:05:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure para gestionar Sexo
ALTER PROCEDURE [dbo].[spGestionarSexo]
    @Modo INT, -- Valor que representa la operación a realizar (1 = CREATE, 2 = READ, 3 = UPDATE, 4 = DELETE)
    @SexoID INT = NULL,
    @Nombre NVARCHAR(20) = NULL
AS
BEGIN
    IF @Modo = 1  -- CREATE
    BEGIN
        INSERT INTO Sexo (Nombre)
        VALUES (@Nombre);

		-- Obtener el último ID insertado
        SELECT SCOPE_IDENTITY() AS ID;
    END;

    IF @Modo = 2  -- READ
    BEGIN
        SELECT * FROM Sexo WHERE SexoID = @SexoID;
    END;

    IF @Modo = 3  -- UPDATE
    BEGIN
        UPDATE Sexo
        SET Nombre = @Nombre
        WHERE SexoID = @SexoID;
    END;

    IF @Modo = 4  -- DELETE
    BEGIN
        DELETE FROM Sexo WHERE SexoID = @SexoID;
    END;

	IF @Modo = 5 -- Combo
	BEGIN
		SELECT SexoID AS Id,
			   Nombre AS Valor
		  FROM Sexo;
	END;
END;


USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarSolicitudInformes]    Script Date: 6/23/2025 9:06:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spGestionarSolicitudInformes]
    @Modo INT,
    @InformeID INT = NULL,
    @InformeTipoID INT = NULL,
    @UsuarioID INT = NULL,
    @FechaUltimaModificacion DATETIME = NULL,
	@PlacaVIN NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.SolicitudInformes (
            InformeTipoID, UsuarioID, FechaUltimaModificacion, PlacaVIN
        )
        VALUES (
            @InformeTipoID, @UsuarioID, @FechaUltimaModificacion, @PlacaVIN
        )
		
		-- Obtener el último ID insertado
        SELECT SCOPE_IDENTITY() AS ID;
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.SolicitudInformes
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de búsqueda
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.SolicitudInformes
        SET InformeTipoID = @InformeTipoID,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion,
			PlacaVIN = @PlacaVIN
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.SolicitudInformes
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE IF @Modo = 5 -- Consulta
    BEGIN
        SELECT si.InformeID,
               si.InformeTipoID,
               si.UsuarioID,
               si.FechaUltimaModificacion,
               v.placa,
               v.niv
          FROM dbo.SolicitudInformes si
          INNER JOIN dbo.Vehiculos v
            ON si.InformeID = v.InformeID ORDER BY si.InformeID DESC
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END    
END



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarTenencias]    Script Date: 6/23/2025 9:06:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGestionarTenencias]
    @Modo INT,
    @InformeID INT = NULL,
    @UsuarioID INT = NULL,
    @FechaUltimaModificacion DATETIME = NULL,
    @Ejercicio INT = NULL,
    @Refrendo FLOAT = NULL,
    @Tenencia FLOAT = NULL,
    @Total FLOAT = NULL,
    @LineaCaptura VARCHAR(MAX) = NULL,
    @Vigencia VARCHAR(MAX) = NULL,
    @DagID VARCHAR(MAX) = NULL,
    @LineaCapturaCB VARCHAR(MAX) = NULL
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.Tenencias (
            InformeID, UsuarioID, FechaUltimaModificacion, Ejercicio, Refrendo, Tenencia, Total,
            LineaCaptura, Vigencia, DagID, LineaCapturaCB
        )
        VALUES (
            @InformeID, @UsuarioID, @FechaUltimaModificacion, @Ejercicio, @Refrendo, @Tenencia, @Total,
            @LineaCaptura, @Vigencia, @DagID, @LineaCapturaCB
        )
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.Tenencias
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de búsqueda		
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.Tenencias
        SET InformeID = @InformeID,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion,
            Ejercicio = @Ejercicio,
            Refrendo = @Refrendo,
            Tenencia = @Tenencia,
            Total = @Total,
            LineaCaptura = @LineaCaptura,
            Vigencia = @Vigencia,
            DagID = @DagID,
            LineaCapturaCB = @LineaCapturaCB
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.Tenencias
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END
END


USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarValuacionDanios]    Script Date: 6/23/2025 9:06:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGestionarValuacionDanios]
    @Modo INT,
    @fecha_valuacion NVARCHAR(MAX),
    @fecha_actualizacion NVARCHAR(MAX),
    @monto_total FLOAT,
    @resultado NVARCHAR(MAX),
    @piezas_reparadas INT,
    @piezas_reemplazadas INT,
    @piezas_pintadas INT,
    @tipo_vehiculo NVARCHAR(MAX),
    @placa NVARCHAR(MAX),
    @gravedad NVARCHAR(MAX),
    @modelo INT,
    @UsuarioID INT,
    @FechaUltimaModificacion DATETIME,
    @InformeID INT = NULL
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.Valuacion_Danios (
            fecha_valuacion, fecha_actualizacion, monto_total, resultado, piezas_reparadas,
            piezas_reemplazadas, piezas_pintadas, tipo_vehiculo, placa, gravedad,
            modelo, UsuarioID, FechaUltimaModificacion, InformeID
        )
        VALUES (
            @fecha_valuacion, @fecha_actualizacion, @monto_total, @resultado, @piezas_reparadas,
            @piezas_reemplazadas, @piezas_pintadas, @tipo_vehiculo, @placa, @gravedad,
            @modelo, @UsuarioID, @FechaUltimaModificacion, @InformeID
        )
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.Valuacion_Danios
        WHERE fecha_valuacion = @fecha_valuacion -- Ajusta esta condición según tus necesidades de búsqueda
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.Valuacion_Danios
        SET fecha_actualizacion = @fecha_actualizacion,
            monto_total = @monto_total,
            resultado = @resultado,
            piezas_reparadas = @piezas_reparadas,
            piezas_reemplazadas = @piezas_reemplazadas,
            piezas_pintadas = @piezas_pintadas,
            tipo_vehiculo = @tipo_vehiculo,
            placa = @placa,
            gravedad = @gravedad,
            modelo = @modelo,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion,
            InformeID = @InformeID
        WHERE fecha_valuacion = @fecha_valuacion -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.Valuacion_Danios
        WHERE fecha_valuacion = @fecha_valuacion -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END
END



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarVehiculos]    Script Date: 6/23/2025 9:07:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGestionarVehiculos]
(
    @Modo INT,
    @Placa NVARCHAR(MAX) = NULL,
    @NIV NVARCHAR(MAX) = NULL,
    @Marca NVARCHAR(MAX) = NULL,
    @Clase NVARCHAR(MAX) = NULL,
    @Modelo INT = NULL,
    @Submarca NVARCHAR(MAX) = NULL,
    @Version NVARCHAR(MAX) = NULL,
    @Tipo NVARCHAR(MAX) = NULL,
    @Desplazamiento NVARCHAR(MAX) = NULL,
    @NumeroCilindros NVARCHAR(MAX) = NULL,
    @PaisOrigen NVARCHAR(MAX) = NULL,
    @Puertas NVARCHAR(MAX) = NULL,
    @Ejes NVARCHAR(MAX) = NULL,
    @PlantaEnsamble NVARCHAR(MAX) = NULL,
    @Complementarios NVARCHAR(MAX) = NULL,
    @InstitucionInscripcion NVARCHAR(MAX) = NULL,
    @FechaInscripcion NVARCHAR(MAX) = NULL,
    @HoraInscripcion NVARCHAR(MAX) = NULL,
    @FechaEmplacado NVARCHAR(MAX) = NULL,
    @UltimaActualizacion NVARCHAR(MAX) = NULL,
    @FolioConstanciaInscripcion NVARCHAR(MAX) = NULL,
    @NumeroConstanciaInscripcion NVARCHAR(MAX) = NULL,
    @Comentarios NVARCHAR(MAX) = NULL,
    @FechaFacturacion NVARCHAR(MAX) = NULL,
    @MontoFacturacion NVARCHAR(MAX) = NULL,
    @CodigoEstado NVARCHAR(MAX) = NULL,
    @Entidad NVARCHAR(MAX) = NULL,
	@InformeID INT = NULL,
    @UsuarioID INT = NULL,
    @FechaUltimaModificacion DATETIME = NULL
)
AS
BEGIN
    IF @Modo = 1 -- Insertar
    BEGIN
        INSERT INTO dbo.Vehiculos
        (
            [placa],
            [niv],
            [marca],
            [clase],
            [modelo],
            [submarca],
            [version],
            [tipo],
            [desplazamiento],
            [numero_cilindros],
            [pais_origen],
            [puertas],
            [ejes],
            [planta_ensamble],
            [complementarios],
            [institucion_inscripcion],
            [fecha_inscripcion],
            [hora_inscripcion],
            [fecha_emplacado],
            [ultima_actualizacion],
            [folio_constancia_inscripcion],
            [numero_constancia_inscripcion],
            [comentarios],
            [fecha_facturacion],
            [monto_facturacion],
            [codigo_estado],
            [entidad],
            [UsuarioID],
            [FechaUltimaModificacion], [InformeID]
        )
        VALUES
        (
            @Placa,
            @NIV,
            @Marca,
            @Clase,
            @Modelo,
            @Submarca,
            @Version,
            @Tipo,
            @Desplazamiento,
            @NumeroCilindros,
            @PaisOrigen,
            @Puertas,
            @Ejes,
            @PlantaEnsamble,
            @Complementarios,
            @InstitucionInscripcion,
            @FechaInscripcion,
            @HoraInscripcion,
            @FechaEmplacado,
            @UltimaActualizacion,
            @FolioConstanciaInscripcion,
            @NumeroConstanciaInscripcion,
            @Comentarios,
            @FechaFacturacion,
            @MontoFacturacion,
            @CodigoEstado,
            @Entidad,
            @UsuarioID,
            @FechaUltimaModificacion, @InformeID
        );
    END
	ELSE IF @Modo = 2 -- Consultar por Placa
    BEGIN
        SELECT
            *
        FROM dbo.Vehiculos
        WHERE InformeID = @InformeID;
    END   
    ELSE IF @Modo = 3 -- Actualizar
    BEGIN
        UPDATE dbo.Vehiculos
        SET
            [niv] = @NIV,
            [marca] = @Marca,
            [clase] = @Clase,
            [modelo] = @Modelo,
            [submarca] = @Submarca,
            [version] = @Version,
            [tipo] = @Tipo,
            [desplazamiento] = @Desplazamiento,
            [numero_cilindros] = @NumeroCilindros,
            [pais_origen] = @PaisOrigen,
            [puertas] = @Puertas,
            [ejes] = @Ejes,
            [planta_ensamble] = @PlantaEnsamble,
            [complementarios] = @Complementarios,
            [institucion_inscripcion] = @InstitucionInscripcion,
            [fecha_inscripcion] = @FechaInscripcion,
            [hora_inscripcion] = @HoraInscripcion,
            [fecha_emplacado] = @FechaEmplacado,
            [ultima_actualizacion] = @UltimaActualizacion,
            [folio_constancia_inscripcion] = @FolioConstanciaInscripcion,
            [numero_constancia_inscripcion] = @NumeroConstanciaInscripcion,
            [comentarios] = @Comentarios,
            [fecha_facturacion] = @FechaFacturacion,
            [monto_facturacion] = @MontoFacturacion,
            [codigo_estado] = @CodigoEstado,
            [entidad] = @Entidad,
            [FechaUltimaModificacion] = @FechaUltimaModificacion
        WHERE InformeID = @InformeID;
    END
    ELSE IF @Modo = 4 -- Eliminar
    BEGIN
        DELETE FROM dbo.Vehiculos
        WHERE [placa] = @Placa;
    END     
END;



USE [app_Checkalo]
GO
/****** Object:  StoredProcedure [dbo].[spGestionarVersiones]    Script Date: 6/23/2025 9:07:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spGestionarVersiones]
    @Modo INT,
    @CLASE VARCHAR(50) = NULL,
    @MARCA VARCHAR(50) = NULL,
    @MODELO VARCHAR(50) = NULL,
    @VERSION_C VARCHAR(255) = NULL,
    @ANO INT = NULL,
    @TIPO VARCHAR(50) = NULL,
    @PUERTAS VARCHAR(50) = NULL,
    @MOTOR VARCHAR(50) = NULL,
    @NO_CILINDRO VARCHAR(50) = NULL,
    @POTENCIA VARCHAR(50) = NULL,
    @COMBUSTIBLE VARCHAR(50) = NULL,
    @TRANSMISION VARCHAR(50) = NULL,
    @TRACCION VARCHAR(50) = NULL,
    @TIPO_DE_DIRECCION VARCHAR(50) = NULL,
    @INTERIORES VARCHAR(50) = NULL,
    @BOLSA_DE_AIRE VARCHAR(50) = NULL,
    @AIRE_ACONDICIONADO VARCHAR(50) = NULL,
    @ELEVADORES_ELECTRICOS VARCHAR(50) = NULL,
    @QUEMACOCOS VARCHAR(50) = NULL,
    @ESTEREO VARCHAR(50) = NULL,
    @TIPO_DE_RIN VARCHAR(50) = NULL,
    @RIN VARCHAR(50) = NULL,
    @NEUMATICO VARCHAR(50) = NULL,
    @FRENOS_DEL VARCHAR(255) = NULL,
    @FRENOS_TRA VARCHAR(255) = NULL,
    @SUSPENSION_DELANTERA VARCHAR(255) = NULL,
    @SUSPENSION_TRASERA VARCHAR(255) = NULL,
    @TIPO_DE_CABINA VARCHAR(50) = NULL,
    @TECHO VARCHAR(50) = NULL,
    @PASAJEROS INT = NULL,
    @VALVULAS INT = NULL,
    @P_LISTA DECIMAL(18,4) = NULL,
    @PRECIO_VENTA DECIMAL(18,4) = NULL,
    @P_COMPRA DECIMAL(18,4) = NULL,
    @VIN VARCHAR(50) = NULL,
    @RESULTADO INT = NULL,
    @DESC_RESULTADO VARCHAR(255) = NULL,
    @ID_CATALOGO VARCHAR(50) = NULL,
    @InformeID INT = NULL,
    @UsuarioID INT,
    @FechaUltimaModificacion DATETIME
AS
BEGIN
    IF @Modo = 1 -- CREATE
    BEGIN
        INSERT INTO dbo.versiones (
            CLASE, MARCA, MODELO, VERSION_C, ANO, TIPO, PUERTAS, MOTOR, NO_CILINDRO, POTENCIA,
            COMBUSTIBLE, TRANSMISION, TRACCION, TIPO_DE_DIRECCION, INTERIORES, BOLSA_DE_AIRE,
            AIRE_ACONDICIONADO, ELEVADORES_ELECTRICOS, QUEMACOCOS, ESTEREO, TIPO_DE_RIN, RIN,
            NEUMATICO, FRENOS_DEL, FRENOS_TRA, SUSPENSION_DELANTERA, SUSPENSION_TRASERA,
            TIPO_DE_CABINA, TECHO, PASAJEROS, VALVULAS, P_LISTA, PRECIO_VENTA, P_COMPRA, VIN,
            RESULTADO, DESC_RESULTADO, ID_CATALOGO, InformeID, UsuarioID, FechaUltimaModificacion
        )
        VALUES (
            @CLASE, @MARCA, @MODELO, @VERSION_C, @ANO, @TIPO, @PUERTAS, @MOTOR, @NO_CILINDRO, @POTENCIA,
            @COMBUSTIBLE, @TRANSMISION, @TRACCION, @TIPO_DE_DIRECCION, @INTERIORES, @BOLSA_DE_AIRE,
            @AIRE_ACONDICIONADO, @ELEVADORES_ELECTRICOS, @QUEMACOCOS, @ESTEREO, @TIPO_DE_RIN, @RIN,
            @NEUMATICO, @FRENOS_DEL, @FRENOS_TRA, @SUSPENSION_DELANTERA, @SUSPENSION_TRASERA,
            @TIPO_DE_CABINA, @TECHO, @PASAJEROS, @VALVULAS, @P_LISTA, @PRECIO_VENTA, @P_COMPRA, @VIN,
            @RESULTADO, @DESC_RESULTADO, @ID_CATALOGO, @InformeID, @UsuarioID, @FechaUltimaModificacion
        )
    END
    ELSE IF @Modo = 2 -- READ
    BEGIN
        SELECT *
        FROM dbo.versiones
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de búsqueda
    END
    ELSE IF @Modo = 3 -- UPDATE
    BEGIN
        UPDATE dbo.versiones
        SET CLASE = @CLASE,
            MARCA = @MARCA,
            MODELO = @MODELO,
            VERSION_C = @VERSION_C,
            ANO = @ANO,
            TIPO = @TIPO,
            PUERTAS = @PUERTAS,
            MOTOR = @MOTOR,
            NO_CILINDRO = @NO_CILINDRO,
            POTENCIA = @POTENCIA,
            COMBUSTIBLE = @COMBUSTIBLE,
            TRANSMISION = @TRANSMISION,
            TRACCION = @TRACCION,
            TIPO_DE_DIRECCION = @TIPO_DE_DIRECCION,
            INTERIORES = @INTERIORES,
            BOLSA_DE_AIRE = @BOLSA_DE_AIRE,
            AIRE_ACONDICIONADO = @AIRE_ACONDICIONADO,
            ELEVADORES_ELECTRICOS = @ELEVADORES_ELECTRICOS,
            QUEMACOCOS = @QUEMACOCOS,
            ESTEREO = @ESTEREO,
            TIPO_DE_RIN = @TIPO_DE_RIN,
            RIN = @RIN,
            NEUMATICO = @NEUMATICO,
            FRENOS_DEL = @FRENOS_DEL,
            FRENOS_TRA = @FRENOS_TRA,
            SUSPENSION_DELANTERA = @SUSPENSION_DELANTERA,
            SUSPENSION_TRASERA = @SUSPENSION_TRASERA,
            TIPO_DE_CABINA = @TIPO_DE_CABINA,
            TECHO = @TECHO,
            PASAJEROS = @PASAJEROS,
            VALVULAS = @VALVULAS,
            P_LISTA = @P_LISTA,
            PRECIO_VENTA = @PRECIO_VENTA,
            P_COMPRA = @P_COMPRA,
            VIN = @VIN,
            RESULTADO = @RESULTADO,
            DESC_RESULTADO = @DESC_RESULTADO,
            ID_CATALOGO = @ID_CATALOGO,
            UsuarioID = @UsuarioID,
            FechaUltimaModificacion = @FechaUltimaModificacion
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de actualización
    END
    ELSE IF @Modo = 4 -- DELETE
    BEGIN
        DELETE FROM dbo.versiones
        WHERE InformeID = @InformeID -- Ajusta esta condición según tus necesidades de eliminación
    END
    ELSE
    BEGIN
        RAISERROR('Modo inválido. Los valores permitidos para @Modo son 1, 2, 3 o 4.', 16, 1)
        RETURN
    END
END

