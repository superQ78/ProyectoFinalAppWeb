<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    if (nombreUsuario == null) {
        response.sendRedirect("InicioPeliculaServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Filmoteca</title>
        <link rel="stylesheet" href="estiloInicioPelicula.css">
    </head>
    <body>
        <header class="header">
            <h1>Bienvenido a tu filmoteca <%= nombreUsuario%>!</h1>
        </header>

        <nav class="nav-bar">
            <ul>
                <li>
                    <a class="nav-link" href="ResgitrarPelicula.jsp">
                        Registrar Película
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="VerPeliculasServlet">
                        Mis Películas
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="FavoritosServlet">
                        Favoritas
                    </a>
                </li>
                <li style="margin-left: auto;">
                    <a class="nav-link" href="LogoutServlet" onclick="return confirmarCierreSesion()">
                        Cerrar Sesión
                    </a>
                </li>
            </ul>
        </nav>

        <div class="search-bar-container">
            <form action="BuscarPeliculasServlet" method="get" class="search-form">
                <input type="text" name="titulo" id="searchInput" placeholder="Buscar películas..." required onkeyup="buscarPeliculas()">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <div id="suggestions-container">
            </div>
        </div>

        <main class="content">
            <div class="carousel-container">
                <c:if test="${not empty listaPeliculas}">
                    <c:forEach var="pelicula" items="${listaPeliculas}" varStatus="loop">
                        <div class="carousel-slide" style="display: ${loop.index == 0 ? 'block' : 'none'}">
                            <c:if test="${not empty pelicula.imagen}">
                                <img src="${pelicula.imagen}" alt="${pelicula.titulo}" onclick="window.location.href = 'VerDetallesPeliculaServlet?id=${pelicula.id}'" style="cursor: pointer;">
                            </c:if>
                            <div class="pelicula-info">
                                <h3 onclick="window.location.href = 'VerDetallesPeliculaServlet?id=${pelicula.id}'" style="cursor: pointer;">${pelicula.titulo}</h3>
                                <p>${pelicula.descripcion}</p>
                            </div>
                        </div>
                    </c:forEach>
                    <button class="carousel-prev" onclick="changeSlide(-1)">&#10094;</button>
                    <button class="carousel-next" onclick="changeSlide(1)">&#10095;</button>
                    <div style="text-align:center">
                        <c:forEach var="pelicula" items="${listaPeliculas}" varStatus="loop">
                            <span class="dot" onclick="currentSlide(${loop.index})"></span>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty listaPeliculas}">
                    <p>No hay películas para mostrar en el carrusel.</p>
                </c:if>
            </div>
        </main>

        <script>
            let slideIndex = 0;
            let slides = document.querySelectorAll('.carousel-slide');
            let dots = document.querySelectorAll('.dot');
            let totalSlides = slides.length;

            function showSlide(n) {
                let i;
                if (n >= totalSlides) {
                    slideIndex = 0
                }
                if (n < 0) {
                    slideIndex = totalSlides - 1
                }
                for (i = 0; i < totalSlides; i++) {
                    slides[i].style.display = "none";
                }
                for (i = 0; i < dots.length; i++) {
                    dots[i].className = dots[i].className.replace(" active", "");
                }
                if (totalSlides > 0) {
                    slides[slideIndex].style.display = "block";
                    if (dots.length > 0) {
                        dots[slideIndex].className += " active";
                    }
                }
            }

            function changeSlide(n) {
                showSlide(slideIndex += n);
            }

            function currentSlide(n) {
                showSlide(slideIndex = n);
            }

            // Mostrar la primera película al cargar la página si hay películas
            if (totalSlides > 0) {
                showSlide(slideIndex);

                // Opcional: Autoplay del carrusel
                setInterval(() => {
                    changeSlide(1);
                }, 3000); // Cambia de slide cada 3 segundos
            }
        </script>

        <script>

            function confirmarCierreSesion() {
                return confirm('¿Estás seguro de que deseas cerrar sesión?');
            }

            /* Al buscar las películas, deben de ir apareciendo */
            function buscarPeliculas() {
                const input = document.getElementById('searchInput').value;
                const suggestionsContainer = document.getElementById('suggestions-container');

                suggestionsContainer.innerHTML = ''; // Limpiar sugerencias anteriores

                if (input.length >= 2) {
                    fetch('BuscarPeliculasSugerenciasServlet?term=' + input)
                            .then(response => response.json())
                            .then(data => {
                                if (data && data.length > 0) {
                                    data.forEach(pelicula => {
                                        const suggestion = document.createElement('div');
                                        suggestion.classList.add('suggestion-item');
                                        suggestion.textContent = pelicula.getTitulo();
                                        suggestion.addEventListener('click', function () {
                                            document.getElementById('searchInput').value = pelicula.getTitulo();
                                            suggestionsContainer.innerHTML = '';
                                        });
                                        suggestionsContainer.appendChild(suggestion);
                                    });
                                } else {
                                    const noSuggestions = document.createElement('div');
                                    noSuggestions.classList.add('no-suggestions');

                                    suggestionsContainer.appendChild(noSuggestions);
                                }
                            })
                            .catch(error => {
                                console.error('Error al buscar sugerencias:', error);
                            });
                }
            }
        </script>
    </body>
</html>