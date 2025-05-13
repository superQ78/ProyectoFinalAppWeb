/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Control;

import DAO.PeliculaDAO;
import DTO.PeliculaDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.bson.types.ObjectId;

@WebServlet("/EditarPeliculaServlet")
public class EditarPeliculaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");
        
        if (usuarioId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String peliculaId = request.getParameter("peliculaId");
        if (peliculaId == null || peliculaId.isEmpty()) {
            response.sendRedirect("VerPeliculas.jsp");
            return;
        }

        PeliculaDTO pelicula = PeliculaDAO.obtenerPorId(new ObjectId(peliculaId));
        
        if (pelicula == null || !pelicula.getUsuarioId().equals(usuarioId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permisos");
            return;
        }

        request.setAttribute("pelicula", pelicula);
        request.getRequestDispatcher("editarPelicula.jsp").forward(request, response);
    }
}