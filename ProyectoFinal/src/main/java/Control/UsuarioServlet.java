/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Control;

import DTO.UsuarioDTO;
import Negocio.UsuarioBO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author cesar
 */
public class UsuarioServlet extends HttpServlet {

    private UsuarioBO usuarioBO = new UsuarioBO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            UsuarioDTO usuario = new UsuarioDTO(
                    request.getParameter("nomUsuario"),
                    request.getParameter("nombre"),
                    request.getParameter("correo"),
                    request.getParameter("contrasena"),
                    request.getParameter("rol")
            );

            boolean exito = usuarioBO.registrarUsuario(usuario);
            if (exito) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("registro.jsp?error=duplicado");
            }
        } else if ("login".equals(accion)) {
            UsuarioDTO usuario = usuarioBO.login(
                    request.getParameter("correo"),
                    request.getParameter("contrasena")
            );
            if (usuario != null) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", usuario);
                response.sendRedirect("peliculas.jsp");
            } else {
                response.sendRedirect("login.jsp?error=credenciales");
            }
        }
    }
}
