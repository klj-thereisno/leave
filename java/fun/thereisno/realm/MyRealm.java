package fun.thereisno.realm;

import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.annotation.Resource;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;

public class MyRealm extends AuthorizingRealm{

	@Resource
	private IdentityService identityService;
	
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		Object principal = principals.getPrimaryPrincipal();
		List<Group> groups = identityService.createGroupQuery().groupMember(principal.toString()).list();
		Set<String> roles = new TreeSet<String>();
		for (Group group : groups) {
			roles.add(group.getId());
		}
		info.setRoles(roles);
		return info;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		String userName = (String) token.getPrincipal();
		User user = identityService.createUserQuery().userId(userName).singleResult();
		if(user != null){
			SecurityUtils.getSubject().getSession().setAttribute("currentUser", user);
			return new SimpleAuthenticationInfo(user.getId(), user.getPassword(), getClass().getSimpleName());
		}
		return null;
	}

}
