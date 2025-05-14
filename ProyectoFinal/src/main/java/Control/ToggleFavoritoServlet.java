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

/**
 *
 * @author cesar
 */
@WebServlet("/ToggleFavoritoServlet")
public class ToggleFavoritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usuarioId = (String) session.getAttribute("usuarioId");

        if (usuarioId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Obtener el ID de la película
        ObjectId peliculaId = new ObjectId(request.getParameter("peliculaId"));

        // Obtener la película
        PeliculaDTO pelicula = PeliculaDAO.obtenerPorId(peliculaId);

        if (pelicula != null && pelicula.getUsuarioId().equals(usuarioId)) {
            // Alternar estado de favorito
            boolean nuevoEstado = !pelicula.isFavorita(); // 📌 Si es favorita, quitarla; si no, agregarla
            pelicula.setFavorita(nuevoEstado);
            PeliculaDAO.actualizarPelicula(pelicula);
        }

        response.setStatus(HttpServletResponse.SC_OK);
    }
}
