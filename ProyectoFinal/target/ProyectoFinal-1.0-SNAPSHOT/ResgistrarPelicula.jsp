<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String errorMensaje = (String) request.getAttribute("errorMensaje");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Película</title>
        <link rel="stylesheet" href="estiloRegistrarPelicula.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    </head>
    <body class="body-cine">
        <main class="registro-container">
            <header class="registro-header">
                <h1>🎬 Registrar Nueva Película</h1>
            </header>

            <section class="registro-form-card">
                <% if (errorMensaje != null && !errorMensaje.isEmpty()) {%>
                <p class="mensaje-error"><%= errorMensaje%></p>
                <% }%>
                <form method="post" action="RegistrarPeliculaServlet" enctype="multipart/form-data" class="registro-form">
                    <div class="form-group">
                        <label for="titulo">🎞️ Título de la película:</label>
                        <input type="text" name="titulo" id="titulo" required>
                    </div>

                    <div class="form-group">
                        <label for="descripcion">📝 Descripción:</label>
                        <textarea name="descripcion" id="descripcion" rows="3"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="calificacion">⭐ Calificación:</label>
                        <select name="calificacion" id="calificacion">
                            <option value="1">★</option>
                            <option value="2">★★</option>
                            <option value="3">★★★</option>
                            <option value="4">★★★★</option>
                            <option value="5">★★★★★</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="genero">🎭 Género:</label>
                        <input type="text" name="genero" id="genero">
                    </div>

                    <div class="form-group">
                        <label for="comentario">💬 Comentario:</label>
                        <textarea name="comentario" id="comentario" rows="2"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="imagen">🖼️ Imagen de portada:</label>
                        <input type="file" name="imagen" id="imagen" accept="image/*">
                    </div>

                    <button type="submit" class="btn-registrar">🎥 Registrar Película</button>
                </form>

                <div class="registro-actions">
                    <a href="InicioPeliculaServlet" class="btn-volver">⬅ Volver al Inicio</a>
                </div>
            </section>
        </main>
    </body>
</html>