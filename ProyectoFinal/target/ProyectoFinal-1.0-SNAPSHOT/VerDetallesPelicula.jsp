<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DTO.PeliculaDTO" %>
<% PeliculaDTO pelicula = (PeliculaDTO) request.getAttribute("pelicula");%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title><%= (pelicula != null) ? pelicula.getTitulo() : "Detalles de la Película"%></title>
        <link rel="stylesheet" href="estiloVerDetallePelicula.css">
    </head>
    <body>
        <main class="contenedor-detalle">
            <header class="detalle-header">
                <h1><%= (pelicula != null) ? pelicula.getTitulo() : "Detalles de la Película"%></h1>
            </header>

            <section class="detalle-content">
                <div class="detalle-imagen">
                    <% if (pelicula != null && pelicula.getImagen() != null && !pelicula.getImagen().isEmpty()) { %>
                    <% String imagenDetalleUrl = pelicula.getImagen();
                        if (!imagenDetalleUrl.startsWith("uploads/")) {
                            imagenDetalleUrl = "uploads/" + imagenDetalleUrl;
                        }
                    %>
                    <img src="<%= imagenDetalleUrl%>" alt="Portada de <%= pelicula.getTitulo()%>">
                    <% } else { %>
                    <div class="sin-imagen-detalle">Sin imagen disponible</div>
                    <% } %>
                </div>

                <div class="detalle-info">
                    <% if (pelicula != null) {%>
                    <p><strong>Descripción:</strong> <%= pelicula.getDescripcion()%></p>
                    <p><strong>Género:</strong> <%= pelicula.getGenero()%></p>
                    <p><strong>Calificación:</strong> <%= pelicula.getCalificacion()%>/5</p>
                    <% if (pelicula.getComentario() != null && !pelicula.getComentario().isEmpty()) {%>
                    <p><strong>Comentario:</strong> <%= pelicula.getComentario()%></p>
                    <% } %>
                    <% } else { %>
                    <p class="mensaje-error">No se encontraron los detalles de la película.</p>
                    <% }%>
                </div>
            </section>

            <footer class="detalle-footer">
                <button onclick="window.history.back()">Volver Atrás</button>
            </footer>
        </main>
    </body>
</html>