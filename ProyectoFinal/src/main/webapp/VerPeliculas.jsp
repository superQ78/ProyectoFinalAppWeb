<%@ page session="true" %>
<%@ page import="java.util.List, DTO.PeliculaDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Object peliculasObj = request.getAttribute("listaPeliculas");
    List<PeliculaDTO> listaPeliculas = (peliculasObj instanceof List<?>)
            ? (List<PeliculaDTO>) peliculasObj : new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Mis Películas</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="estiloVerPelicula.css">
        <script>
            function toggleFavorito(peliculaId, boton) {
                fetch("ToggleFavoritoServlet", {
                    method: "POST",
                    body: new URLSearchParams({peliculaId: peliculaId})
                }).then(response => {
                    if (response.ok) {
                        boton.children[0].classList.toggle("fas");
                        boton.children[0].classList.toggle("far");
                    }
                }).catch(error => console.error("Error al marcar favorito:", error));
            }
        </script>
    </head>
    <body>
        <h1>Mis Películas</h1>
        <button onclick="window.history.back()" class="btn-atras">Atrás</button>
        <button onclick="window.location.href = 'FavoritosServlet'" class="btn-favoritos-link">
            <i class="fas fa-heart"></i> Ir a Favoritos
        </button>
        <div class="peliculas-container">
            <% if (listaPeliculas.isEmpty()) { %>
            <p>No tienes películas registradas aún.</p>
            <% } else { %>
            <% for (PeliculaDTO pelicula : listaPeliculas) { %>
            <div class="pelicula">
                <%
                    String imagenUrl = pelicula.getImagen();
                    if (imagenUrl == null || imagenUrl.isEmpty()) {
                        imagenUrl = "images/default.jpg"; // Imagen por defecto si no hay portada
                    }
                %>
                <img src="<%= imagenUrl%>" alt="Portada de <%= pelicula.getTitulo()%>" class="portada-img">
                <h2><%= pelicula.getTitulo()%></h2>
                <p><%= pelicula.getDescripcion()%></p>
                <p>🎭 Género: <%= pelicula.getGenero()%></p>
                <p>⭐ Calificación: <%= pelicula.getCalificacion()%>/5</p>

                <!-- 🔹 Estrella para marcar/desmarcar favoritos -->
                <%
                    boolean esFavorita = pelicula.isFavorita();
                    String iconoFavorito = esFavorita ? "fas fa-star" : "far fa-star";
                %>
                <!-- 🔹 Botón de estrella para marcar/desmarcar favoritos -->
                <button class="btn-favorito" onclick="toggleFavorito('<%= pelicula.getId()%>', this)">
                    ⭐ <i class="<%= iconoFavorito%>"></i>
                </button>


                <form action="EliminarPeliculaServlet" method="post" onsubmit="return confirm('¿Seguro que quieres eliminar esta película?');">
                    <input type="hidden" name="peliculaId" value="<%= pelicula.getId()%>">
                    <button type="submit" class="btn-eliminar">🗑️ Eliminar</button>
                </form>
            </div>
            <% } %>
            <% }%>
        </div>
    </body>
</html>