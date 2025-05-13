package Negocio;

import DAO.UsuariosDAO;
import DTO.UsuarioDTO;
import java.util.List;

/**
 *
 * @author cesar
 */
public class UsuarioBO {
  

    public boolean registrarUsuario(UsuarioDTO usuario) {
        return UsuariosDAO.agregar_usuario(usuario);
    }

    public UsuarioDTO login(String correo, String contrasena) {
        return UsuariosDAO.verificarCredenciales(correo, contrasena);
    }

    public List<UsuarioDTO> obtenerUsuariosSiAdmin(String rol) {
        return UsuariosDAO.obtener_lista(rol);
    }

    public void eliminarUsuario(String id) {
        UsuariosDAO.eliminar_usuario(new org.bson.types.ObjectId(id));
    }

    public boolean esAdmin(String id) {
        return UsuariosDAO.esAdmin(new org.bson.types.ObjectId(id));
    }

    public UsuarioDTO obtenerPorId(String id) {
        return UsuariosDAO.obtener_por_id(new org.bson.types.ObjectId(id));
    }
}