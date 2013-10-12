package de.webfilesys.user;

import java.util.Date;
import java.util.Vector;

import de.webfilesys.LanguageManager;
import de.webfilesys.WebFileSys;

/**
 * Very simple user manage
 * 
 * @author Leonardo F. Cardoso
 * 
 */
@SuppressWarnings("rawtypes")
public class SimpleUserManager extends UserManagerBase {

	/**
	 * Fix for "hang" problem when shutting down context
	 */
	public SimpleUserManager() {
		super();
		this.readyForShutdown = true;
	}

	public Vector getListOfUsers() {
		TransientUser adm = new TransientUser();
		adm.setUserid("admin");
		adm.setCss("bluemoon");
		adm.setLanguage("English");
		adm.setReadonly(false);
		adm.setEmail("a@a.com");

		TransientUser usu = new TransientUser();
		usu.setUserid("usu");
		usu.setCss("bluemoon");
		usu.setLanguage("Portugues");
		usu.setReadonly(true);
		usu.setEmail("a@a.com");

		Vector<TransientUser> saida = new Vector<TransientUser>();
		saida.add(adm);
		saida.add(usu);

		return saida;
	}

	public Vector getAdminUserEmails() {
		return new Vector();
	}

	public Vector getMailAddressesByRole(String receiverRole) {
		return new Vector();
	}

	public Vector getAllMailAddresses() {
		return new Vector();
	}

	public boolean addUser(String userId) {
		throw new IllegalArgumentException("M�todo 'addUser' n�o implementado em "
				+ this.getClass().getName());
	}

	public boolean removeUser(String userId) {
		throw new IllegalArgumentException("M�todo 'removeUser' n�o implementado em "
				+ this.getClass().getName());
	}

	public boolean userExists(String userId) {
		return true;
	}

	public String createVirtualUser(String realUser, String docRoot, String role, int expDays) {
		throw new IllegalArgumentException("M�todo 'createVirtualUser' n�o implementado em "
				+ this.getClass().getName());
	}

	public boolean setUserType(String userId, String type) {
		throw new IllegalArgumentException("M�todo 'setUserType' n�o implementado em "
				+ this.getClass().getName());
	}

	public String getUserType(String userId) {
		// null if the user does not exist, "default" if the user type has not ben set
		return "default";
	}

	public String getFirstName(String userId) {
		return "No Name";
	}

	public void setFirstName(String userId, String newValue) {
		throw new IllegalArgumentException("M�todo 'setFirstName' n�o implementado em "
				+ this.getClass().getName());
	}

	public String getLastName(String userId) {
		return "No Name";
	}

	public void setLastName(String userId, String newValue) {
		throw new IllegalArgumentException("M�todo 'setLastName' n�o implementado em "
				+ this.getClass().getName());
	}

	public String getEmail(String userId) {
		return "noreply@thisemaildoesnotexists.com.com.br";
	}

	public void setEmail(String userId, String newValue) {
		throw new IllegalArgumentException("M�todo 'setEmail' n�o implementado em "
				+ this.getClass().getName());
	}

	public long getDiskQuota(String userId) {
		return 0;
	}

	public void setDiskQuota(String userId, long newValue) {
		throw new IllegalArgumentException("M�todo 'setDiskQuota' n�o implementado em "
				+ this.getClass().getName());
	}

	public int getPageSize(String userId) {
		return 0;
	}

	public void setPageSize(String userId, int newValue) {
	}

	public Date getLastLoginTime(String userId) {
		return new Date();
	}

	public void setLastLoginTime(String userId, Date newValue) {
	}

	public String getPhone(String userId) {
		return "2345678";
	}

	public void setPhone(String userId, String newValue) {
		throw new IllegalArgumentException("M�todo 'setPhone' n�o implementado em "
				+ this.getClass().getName());
	}

	public String getLanguage(String userId) {
		return LanguageManager.getInstance().getDefaultLanguage();
	}

	public void setLanguage(String userId, String newValue) {
		throw new IllegalArgumentException("M�todo 'setLanguage' n�o implementado em "
				+ this.getClass().getName());
	}

	public String getRole(String userId) {
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
		return true;
	}

	public void setReadonly(String userId, boolean readonly) {
	}

	public String getDocumentRoot(String userId) {
		String rootPath = WebFileSys.getInstance().getUserDocRoot();
		if (rootPath == null) {
			throw new IllegalArgumentException("UserDocumentRoot must exist in configuration file");
		}
		return rootPath;
	}

	public void setDocumentRoot(String userId, String newValue) {
	}

	public void setPassword(String userId, String newPassword) {
		throw new IllegalArgumentException("M�todo 'setPassword' n�o implementado em "
				+ this.getClass().getName());
	}

	public boolean checkPassword(String userId, String password) {
		return false; // We are using JAAS
	}

	public boolean checkReadonlyPassword(String userId, String password) {
		return false;
	}

	public void setReadonlyPassword(String userId, String newPassword) {
	}

	public String getCSS(String userId) {
		// fmweb, bluemoon, sunset
		return "bluemoon";
	}

	public void setCSS(String userId, String newCSS) {
	}

	public Vector getRealUsers() {
		return new Vector();
	}

	//
	// public synchronized void run() {
	// readyForShutdown = true;
	// }

}
