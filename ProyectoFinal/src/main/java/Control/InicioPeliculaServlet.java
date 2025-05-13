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
@WebServlet("/InicioPeliculaServlet")
public class InicioPeliculaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String nombreUsuario = (String) session.getAttribute("nombreUsuario");
        String usuarioId = (String) session.getAttribute("usuarioId"); // ✅ Recupera usuarioId correctamente

        System.out.println("Usuario ID en sesión al entrar en InicioPeliculaServlet: " + usuarioId);

        if (nombreUsuario == null || usuarioId == null || usuarioId.isEmpty()) {
            System.out.println("⚠ Error: Sesión inválida. Redirigiendo a login.");
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Usar usuarioId como String directamente en la consulta
        List<PeliculaDTO> peliculasUsuario = PeliculaDAO.obtenerPorUsuario(usuarioId);

        System.out.println("🔍 Número de películas recuperadas: " + (peliculasUsuario != null ? peliculasUsuario.size() : "null"));

        if (peliculasUsuario == null) {
            peliculasUsuario = new ArrayList<>(); // ✅ Evita NullPointerException
        }
        request.setAttribute("listaPeliculas", peliculasUsuario);
        request.setAttribute("nombreUsuario", nombreUsuario);

        request.getRequestDispatcher("InicioPelicula.jsp").forward(request, response);
    }
}
