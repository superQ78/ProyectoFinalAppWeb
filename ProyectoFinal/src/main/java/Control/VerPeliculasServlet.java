package Control;

import DAO.PeliculaDAO;
import DTO.PeliculaDTO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author Equipo
 */
@WebServlet("/VerPeliculasServlet")
public class VerPeliculasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");

        System.out.println("Usuario ID en sesión al entrar en VerPeliculasServlet: " + usuarioId);

        if (usuarioId == null || usuarioId.isEmpty()) {
            System.out.println("Error: usuarioId es nulo o vacío. Redirigiendo a login.");
            response.sendRedirect("login.jsp");
            return;
        }

        // 🔹 Obtener películas desde la BD
        List<PeliculaDTO> peliculas = PeliculaDAO.obtenerPorUsuario(usuarioId);

        System.out.println("Número de películas recuperadas: " + (peliculas != null ? peliculas.size() : "null"));

        if (peliculas == null) {
            peliculas = new ArrayList<>();
        }

        request.setAttribute("listaPeliculas", peliculas);
        System.out.println("📤 Enviando lista de películas a VerPeliculas.jsp con tamaño: " + peliculas.size());
        request.getRequestDispatcher("VerPeliculas.jsp").forward(request, response);

        // 🔹 Depuración antes de enviar a la JSP
        if (peliculas.isEmpty()) {
            System.out.println("Advertencia: No hay películas para mostrar.");
        } else {
            for (PeliculaDTO pelicula : peliculas) {
                System.out.println("Enviando película: " + pelicula.getTitulo());
            }
        }
    }
}