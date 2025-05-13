/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
 *
 * @author cesar
 */
@WebServlet("/FavoritosServlet")
public class FavoritosServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId"); // ✅ Recupera como String

        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<PeliculaDTO> favoritas = PeliculaDAO.obtenerFavoritasPorUsuario(usuarioId);

        System.out.println("Número de películas favoritas recuperadas: " + (favoritas != null ? favoritas.size() : "null"));

        if (favoritas != null) {
            for (PeliculaDTO pelicula : favoritas) {
                System.out.println("🔍 Imagen recuperada para " + pelicula.getTitulo() + ": " + pelicula.getImagen());
            }
        }

        request.setAttribute("listaFavoritas", favoritas);
        request.getRequestDispatcher("Favoritos.jsp").forward(request, response);
    }
}
