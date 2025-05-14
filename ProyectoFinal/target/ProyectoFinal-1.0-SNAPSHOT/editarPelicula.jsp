<%-- 
    Document   : editarPelicula
    Created on : May 13, 2025, 3:37:02 PM
    Author     : delll
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DTO.PeliculaDTO" %>
<%
    PeliculaDTO pelicula = (PeliculaDTO) request.getAttribute("pelicula");
    if (pelicula == null) {
        response.sendRedirect("verPeliculas.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Película</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            .form-container {
                max-width: 600px;
                margin: 20px auto;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                background-color: #f9f9f9;
            }
            .portada-preview {
                max-width: 200px;
                max-height: 200px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="form-container">
                <h2 class="mb-4">Editar Película</h2>

                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger"><%= request.getAttribute("error")%></div>
                <% }%>

                <form action="ActualizarPeliculaServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="peliculaId" value="<%= pelicula.getId()%>">
                    <input type="hidden" name="imagenActual" value="<%= pelicula.getImagen()%>">

                    <div class="form-group">
                        <label for="titulo">Título:</label>
                        <input type="text" class="form-control" id="titulo" name="titulo" 
                               value="<%= pelicula.getTitulo()%>" required>
                    </div>

                    <div class="form-group">
                        <label for="descripcion">Descripción:</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="4"><%= pelicula.getDescripcion()%></textarea>
                    </div>

                    <div class="form-group">
                        <label for="genero">Género:</label>
                        <input type="text" class="form-control" id="genero" name="genero" 
                               value="<%= pelicula.getGenero()%>">
                    </div>

                    <div class="form-group">
                        <label for="calificacion">Calificación (1-5):</label>
                        <input type="number" class="form-control" id="calificacion" name="calificacion" 
                               min="1" max="5" value="<%= pelicula.getCalificacion()%>">
                    </div>

                    <div class="form-group">
                        <label for="comentario">Comentario:</label>
                        <input type="text" class="form-control" id="comentario" name="comentario" 
                               value="<%= pelicula.getComentario()%>">
                    </div>

                    <div class="form-group form-check">
                        <input type="checkbox" class="form-check-input" id="favorita" name="favorita" 
                               <%= pelicula.isFavorita() ? "checked" : ""%>>
                        <label class="form-check-label" for="favorita">Favorita</label>
                    </div>

                    <div class="form-group">
                        <label>Portada actual:</label><br>
                        <img src="<%= pelicula.getImagen() != null ? pelicula.getImagen() : "images/default.jpg"%>" 
                             class="portada-preview" id="portadaPreview">
                    </div>

                    <div class="form-group">
                        <label for="imagen">Nueva portada:</label>
                        <input type="file" class="form-control-file" id="imagen" name="imagen" accept="image/*">
                    </div>

                    <button type="submit" class="btn btn-primary mr-2">
                        <i class="fas fa-save"></i> Guardar Cambios
                    </button>

                    <a href="VerPeliculasServlet" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>

                </form>
            </div>
        </div>

        <script>
            // Vista previa de la imagen seleccionada
            document.getElementById('imagen').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        let preview = document.getElementById('portadaPreview');
                        preview.src = e.target.result;
                    }
                    reader.readAsDataURL(file);
                }
            });
        </script>
    </body>
</html>