package de.webfilesys.user;

import java.util.Date;
import java.util.Vector;

/**
 * @author leonardo
 * 
 */
@SuppressWarnings("rawtypes")
public class TestUserManager extends UserManagerBase {

	/**
	 * Fix for "hang" problem when shutting down context
	 */
	public TestUserManager() {
		super();
		this.readyForShutdown = true;
	}

	public Vector getListOfUsers() {
		// TODO get all available users.
		TransientUser adm = new TransientUser();
		adm.setUserid("admin");
		adm.setCss("sunset");
		adm.setDocumentRoot("/");
		adm.setLanguage("English");
		adm.setReadonly(false);
		adm.setEmail("a@a.com");

		TransientUser usu = new TransientUser();
		usu.setUserid("usu");
		usu.setCss("sunset");
		usu.setDocumentRoot("/");
		usu.setLanguage("Portugues");
		usu.setReadonly(true);
		usu.setEmail("a@a.com");

		Vector<TransientUser> saida = new Vector<TransientUser>();
		saida.add(adm);
		saida.add(usu);

		return saida;
	}

	public Vector getAdminUserEmails() {
		// TODO implement (return emails as strings)?
		return new Vector();
	}

	public Vector getMailAddressesByRole(String receiverRole) {
		// TODO implement (there are 3 roles: admin, user, webspace)
		return new Vector();
	}

	public Vector getAllMailAddresses() {
		// TODO implement
		return new Vector();
	}

	public boolean addUser(String userId) {
		throw new IllegalArgumentException("Método 'addUser' não implementado em "
				+ this.getClass().getName());
	}

	public boolean removeUser(String userId) {
		throw new IllegalArgumentException("Método 'removeUser' não implementado em "
				+ this.getClass().getName());
	}

	public boolean userExists(String userId) {
		// TODO implement
		return true;
	}

	public String createVirtualUser(String realUser, String docRoot, String role, int expDays) {
		throw new IllegalArgumentException("Método 'createVirtualUser' não implementado em "
				+ this.getClass().getName());
	}

	public boolean setUserType(String userId, String type) {
		throw new IllegalArgumentException("Método 'setUserType' não implementado em "
				+ this.getClass().getName());
	}

	public String getUserType(String userId) {
		// null if the user does not exist, "default" if the user type has not ben set
		return "default";
	}

	public String getFirstName(String userId) {
		// TODO implement
		return "Primeiro";
	}

	public void setFirstName(String userId, String newValue) {
		throw new IllegalArgumentException("Método 'setFirstName' não implementado em "
				+ this.getClass().getName());
	}

	public String getLastName(String userId) {
		// TODO implement
		return "Ultimo";
	}

	public void setLastName(String userId, String newValue) {
		throw new IllegalArgumentException("Método 'setLastName' não implementado em "
				+ this.getClass().getName());
	}

	public String getEmail(String userId) {
		// TODO implement
		return "email@email.com";
	}

	public void setEmail(String userId, String newValue) {
		throw new IllegalArgumentException("Método 'setEmail' não implementado em "
				+ this.getClass().getName());
	}

	public long getDiskQuota(String userId) {
		return 0;
	}

	public void setDiskQuota(String userId, long newValue) {
		throw new IllegalArgumentException("Método 'setDiskQuota' não implementado em "
				+ this.getClass().getName());
	}

	public int getPageSize(String userId) {
		return 0;
	}

	public void setPageSize(String userId, int newValue) {
	}

	public Date getLastLoginTime(String userId) {
		// TODO - implement (pegar do AD)
		return new Date();
	}

	public void setLastLoginTime(String userId, Date newValue) {
	}

	public String getPhone(String userId) {
		// TODO implement
		return "2222";
	}

	public void setPhone(String userId, String newValue) {
		throw new IllegalArgumentException("Método 'setPhone' não implementado em "
				+ this.getClass().getName());
	}

	public String getLanguage(String userId) {
		return "Portugues";
	}

	public void setLanguage(String userId, String newValue) {
		throw new IllegalArgumentException("Método 'setLanguage' não implementado em "
				+ this.getClass().getName());
	}

	public String getRole(String userId) {
		// TODO implementar lógica dos grupos
		// admin, user, webspace
		if ("admin".equalsIgnoreCase(userId)) {
			return "admin";
		} else {
			return "webspace";
		}
	}

	public void setRole(String userId, String newRole) {
	}

	public boolean isReadonly(String userId) {
		// Todos são readonly
		return true;
	}

	public void setReadonly(String userId, boolean readonly) {
	}

	public String getDocumentRoot(String userId) {
		// TODO read from config file or context param
		return "/tmp/webfilesys";
	}

	public void setDocumentRoot(String userId, String newValue) {
	}

	public void setPassword(String userId, String newPassword) {
		throw new IllegalArgumentException("Método 'setPassword' não implementado em "
				+ this.getClass().getName());
	}

	public boolean checkPassword(String userId, String password) {
		// TODO verificar password
		if ("admin".equalsIgnoreCase(userId)) {
			return "gseg123-leonardo".equalsIgnoreCase(password);
		}
		return true;
	}

	public boolean checkReadonlyPassword(String userId, String password) {
		return false;
	}

	public void setReadonlyPassword(String userId, String newPassword) {
	}

	public String getCSS(String userId) {
		// fmweb, bluemoon, sunset
		return "sunset";
	}

	public void setCSS(String userId, String newCSS) {
	}

	public Vector getRealUsers() {
		return new Vector();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see de.webfilesys.user.UserManagerBase#run()
	 */

	public synchronized void run() {
		readyForShutdown = true;
	}

}
