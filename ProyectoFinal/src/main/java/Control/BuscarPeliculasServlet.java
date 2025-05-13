/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Control;

import DTO.PeliculaDTO;
import Negocio.PeliculaBO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author cesar
 */
@WebServlet("/BuscarPeliculasServlet")
public class BuscarPeliculasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String titulo = request.getParameter("titulo");
        String usuarioId = (String) request.getSession().getAttribute("usuarioId"); // 🔹 Usa tu nombre de atributo real

        PeliculaBO peliculaBO = new PeliculaBO();
        List<PeliculaDTO> peliculasEncontradas = peliculaBO.buscarPorTitulo(titulo, usuarioId);

        request.setAttribute("peliculas", peliculasEncontradas);
        request.setAttribute("busqueda", titulo);
        request.getRequestDispatcher("ResultadosBusqueda.jsp").forward(request, response);
    }
}
