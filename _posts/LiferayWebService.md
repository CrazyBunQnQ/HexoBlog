---
title: Liferay Web Service
date: 2018-07-08 10:40:22
categories: 触类旁通
tags:
- Liferay
- WebService
---

最近项目中需要在移动端（HTML5 页面）中调用 Liferay Portal 接口，奈何网上资料很少而且版本各异，所以就只能硬着头皮啃[官方文档](https://dev.liferay.com/zh/develop/tutorials/-/knowledge_base/6-2/soap-web-services)了...

>这个东西都烂到没有人愿意翻译么 →_→

<!-- more -->

## SOAP WEB SERVICES

您可以通过 HTTP 通过简单对象访问协议(SOAP)访问 Liferay 的服务。打包协议是 SOAP，传输协议是 HTTP。

>**Note**:与身份验证相关的令牌必须伴随每个 Liferay web service 调用。有关详细信息，请阅读本章前面关于服务安全层的一节。

作为一个示例，让我们看看 Liferay 的 `Company`、`User` 和 `UserGroup` portal 服务的 SOAP web service 类，以执行以下操作:

1. 列出 User 测试所属的每个 UserGroup。
2. 添加一个名为 MyGroup 的新 UserGroup。
3. 将 portal 的管理用户添加到新用户组。出于演示目的，我们将使用电子邮件地址为 `test@liferay.com` 的管理用户。

<!-- 向 UserGroup 添加 User 测试。 -->
我们将使用这些与 SOAP 相关的类:

```java
import com.liferay.portal.model.CompanySoap;
import com.liferay.portal.model.UserGroupSoap;
import com.liferay.portal.service.http.CompanyServiceSoap;
import com.liferay.portal.service.http.CompanyServiceSoapServiceLocator;
import com.liferay.portal.service.http.UserGroupServiceSoap;
import com.liferay.portal.service.http.UserGroupServiceSoapServiceLocator;
import com.liferay.portal.service.http.UserServiceSoap;
import com.liferay.portal.service.http.UserServiceSoapServiceLocator;
```

您能看到 SOAP 相关类的命名约定吗?这些类都有后缀 `-ServiceSoapServiceLocator`、`-ServiceSoap` 和`-Soap`。`-ServiceSoapServiceLocator` 类通过您提供的服务 URL 查找 `-ServiceSoap`。`ServiceSoap` 类是每个服务的 Web Service 定义语言(Web services Definition Language, WSDL)文件中指定的服务的接口。`Soap` 类是模型的可序列化实现。让我们看看如何确定这些服务的 URL。

通过打开浏览器到以下 URL ，您可以看到部署在 portal 上的服务列表:

`http://[host]:[port]/api/axis`。

>**Note**:在 Liferay 6.2 之前，有两个不同的 url 用于访问远程 Liferay 服务。`http://[host]:[port]/api/secure/axis` 用于需要验证的服务，`http://[host]:[port]/api/axis` 用于不需要验证的服务。从 Liferay 6.2 开始，所有远程 Liferay 服务都需要身份验证，使用 `http://[host]:[port]/api/axis` URL 访问它们。

以下是 UserGroup 的安全 web 服务列表:

- `Portal_UserGroupService` (wsdl)
    - `addGroupUserGroups`
    - `addTeamUserGroups`
    - `addUserGroup`
    - `deleteUserGroup`
    - `getUserGroup`
    - `getUserUserGroups`
    - `unsetGroupUserGroups`
    - `unsetTeamUserGroups`
    - `updateUserGroup`

>**Note**: Liferay 的开发人员使用一个名为 _Service Builder_ 的工具，通过 SOAP 自动公开他们的服务。如果您对使用 _Service Builder_ 感兴趣，请参阅本指南中的服务构建器章节。

每个 web service 都列出了其名称、操作和到其 WSDL 文件的链接。WSDL 文件是用 XML 编写的，并提供了描述和定位 web service 的模型。

下面是 `UserGroup` 的 `addUserGroup` 操作的 WSDL 摘录:

```xml
<wsdl:operation name="addUserGroup" parametterOrder="name description
publicLayoutSetPropertyId privateLayoutSetPropertyId">
    <wsdl:input message="impl:addUserGroupRequest" name="addUserGroupRequest"/>
    <wsdl:outputMessage="impl:addUserGroupResponse" name="assUserGroupResponse"/>
</wsdl:operation>
```

要使用该服务，您需要将 WSDL URL 连同登录凭证传递给服务的 SOAP 服务定位器 (service locator)。我们将在下一节中向您展示一个示例。

接下来，让我们调用 web service !

<br>

## SOAP JAVA CLIENT

可以使用 Eclipse IDE 轻松地设置 Java web service 客户端。方法如下:

在 Eclipse 中，为计划在客户端代码中使用的每个服务向项目添加一个新的 Web Service Client。对于我们的目的，我们正在构建的客户端需要 portal 的 Company、User 和 User Group 服务的 Web Service Client。

添加您的 Web service 客户端在 Eclipse IDE 中,单击 new → other…,然后点开 Web Services 类别。单击 Web Service Client。

对于您创建的每个客户端，都会提示您输入所需服务的服务定义(WSDL)。由于我们的示例 web service 客户端将使用 Liferay Portal 的 Company、User 和 UserGroup 服务，因此我们需要输入以下 WSDL:

```url
http://localhost:8080/api/axis/Portal_CompanyService?wsdl

http://localhost:8080/api/axis/Portal_UserService?wsdl

http://localhost:8080/api/axis/Portal_UserGroupService?wsdl
```

![新建 Web Service Client](https://dev.liferay.com/documents/12052/378662/api-web-svc-wsdl.png/f35ee8a8-3cc5-4013-7bbe-687d7f2b2f5c?version=1.0&t=1516399490165)

当您指定 WSDL 时，Eclipse 将自动添加使用该 web service 所需的辅助文件和库。非常棒！在您使用上面的 WSDL 之一创建了 web 服务客户端项目之后，您需要使用剩余的 WSDL 在项目中创建其他客户端。在一个现有的项目中创建一个额外的客户端,右键单击项目并选择 New → Web Service Client。单击 Next，输入 WSDL，并完成向导。

下面的代码定位并调用操作来创建一个名为 `MyUserGroup` 的新用户组，并向其添加屏幕显示名称为 _test_ 的用户。在 web service client 项目中创建一个 `LiferaySoapClient.java` 文件，并向其添加以下代码。如果您在一个包中创建这个类，而不是在下面代码中指定的那个包中，那么就用您的包替换这个包。要从 Eclipse 运行客户端，请确保您的 Liferay 服务器正在运行，请右键单击 `LiferaySoapClient.java` 类，并选择 _Run as java application_。检查控制台，检查服务调用是否成功。

```java
package com.liferay.test;

import java.net.URL;

import com.liferay.portal.model.CompanySoap;
import com.liferay.portal.model.UserGroupSoap;
import com.liferay.portal.service.http.CompanyServiceSoap;
import com.liferay.portal.service.http.CompanyServiceSoapServiceLocator;
import com.liferay.portal.service.http.UserGroupServiceSoap;
import com.liferay.portal.service.http.UserGroupServiceSoapServiceLocator;
import com.liferay.portal.service.http.UserServiceSoap;
import com.liferay.portal.service.http.UserServiceSoapServiceLocator;

public class LiferaySoapClient {

    public static void main(String[] args) {

        try {
            String remoteUser = "test";
            String password = "test";
            String virtualHost = "localhost";

            String groupName = "MyUserGroup";

            String serviceCompanyName = "Portal_CompanyService";
            String serviceUserName = "Portal_UserService";
            String serviceUserGroupName = "Portal_UserGroupService";

            long userId = 0;

            // Locate the Company
            CompanyServiceSoapServiceLocator locatorCompany =
                new CompanyServiceSoapServiceLocator();

            CompanyServiceSoap soapCompany =
                locatorCompany.getPortal_CompanyService(
                    _getURL(remoteUser, password, serviceCompanyName,
                            true));

            CompanySoap companySoap =
                soapCompany.getCompanyByVirtualHost(virtualHost);

            // Locate the User service
            UserServiceSoapServiceLocator locatorUser =
                new UserServiceSoapServiceLocator();
            UserServiceSoap userSoap = locatorUser.getPortal_UserService(
                _getURL(remoteUser, password, serviceUserName, true));

            // Get the ID of the remote user
            userId = userSoap.getUserIdByScreenName(
                companySoap.getCompanyId(), remoteUser);
            System.out.println("userId for user named " + remoteUser +
                    " is " + userId);

            // Locate the UserGroup service
            UserGroupServiceSoapServiceLocator locator =
                new UserGroupServiceSoapServiceLocator();
            UserGroupServiceSoap usergroupsoap =
                locator.getPortal_UserGroupService(
                    _getURL(remoteUser, password, serviceUserGroupName,
                            true));

            // Get the user's user groups
            UserGroupSoap[] usergroups = usergroupsoap.getUserUserGroups(
                    userId);

            System.out.println("User groups for userId " + userId + " ...");
            for (int i = 0; i < usergroups.length; i++) {
                System.out.println("\t" + usergroups[i].getName());
            }

            // Adds the user group if it does not already exist
            String groupDesc = "My new user group";
            UserGroupSoap newUserGroup = null;

            boolean userGroupAlreadyExists = false;
            try {
                newUserGroup = usergroupsoap.getUserGroup(groupName);
                if (newUserGroup != null) {
                    System.out.println("User with userId " + userId +
                            " is already a member of UserGroup " +
                                    newUserGroup.getName());
                    userGroupAlreadyExists = true;
                }
            } catch (Exception e) {
                // Print cause, but continue
                System.out.println(e.getLocalizedMessage());
            }

            if (!userGroupAlreadyExists) {
                newUserGroup = usergroupsoap.addUserGroup(
                        groupName, groupDesc);
                System.out.println("Added user group named " + groupName);

                long users[] = {userId};
                userSoap.addUserGroupUsers(newUserGroup.getUserGroupId(),
                        users);
            }

            // Get the user's user groups
            usergroups = usergroupsoap.getUserUserGroups(userId);

            System.out.println("User groups for userId " + userId + " ...");
            for (int i = 0; i < usergroups.length; i++) {
                System.out.println("\t" + usergroups[i].getName());
            }
        }
        catch (Exception e) {
            e.getLocalizedMessage();
        }
    }

        private static URL _getURL(String remoteUser, String password,
                        String serviceName, boolean authenticate)
                        throws Exception {

                // Unauthenticated url
                String url = "http://localhost:8080/api/axis/" + serviceName;

                // Authenticated url
                if (authenticate) {
                        url = "http://" + remoteUser + ":" + password
                                        + "@localhost:8080/api/axis/"
                                        + serviceName;
                }

                return new URL(url);
        }

}
```

运行此客户端应该生成如下示例所示的输出:

```log
userId for user named test is 10196
User groups for user 10196 ...
java.rmi.RemoteException: No UserGroup exists with the key {companyId=10154,
name=MyUserGroup}
Added user group named
Added user to user group named MyUserGroup
User groups for user 10196 ...
    MyUserGroup
```

控制台的输出告诉我们这个用户没有组，然后将这个用户添加到 UserGroup `MyUserGroup`。

您可能会想，“但是抛出了一个错误!” 我们做错了什么事!“ 是的，抛出了一个错误(`java.rmi.RemoteException:`)，但是我们仍然坐在这里，就像一个冰淇淋三明治一样酷。” 抛出异常仅仅是因为在创建 `UserGroup` 之前调用了 `UserGroup` 检查。因为输出的下面几行说 `Added user group named...`，好了。别担心, 要快乐!

关于这个例子，有几点需要注意:

- 身份验证是使用 HTTP Basic 身份验证完成的，这对于生产环境是不合适的，因为密码是未加密的。在本例中，它只是为了方便而使用。在生产中，应该设置 `company.security.auth.requires.https=false`。请参阅 Liferay 的 [`portal.properties`](http://docs.liferay.com/portal/6.2/propertiesdoc/portal.properties.html) 文件以获取更多信息。
- 屏幕名称和密码作为凭证在 URL 中传递。
- 服务的名称(例如，`Portal_UserGroupService`) 在 URL 的末尾指定。请记住，<font color="#FF6666">服务名称可以在 web 服务列表中找到</font>。

操作 `getCompanyByVirtualHost()`、`getUserIdByScreenName()`、`getUserUserGroups()`、`addUserGroup()` 和 `addUserGroupUsers()` 是为 WSDL 文件中的 `-ServiceSOAP` 类 `CompanyServiceSoap`、`UserServiceSoap` 和 `UserGroupServiceSoap` 指定的。关于每个 Liferay web service 的参数类型、参数顺序、请求类型、响应类型和返回类型的信息可以方便地在 WSDL 中指定。一切都在你的身边!

接下来，让我们用 JavaScript 实现 web service 客户端。

>原文[使用 PHP 实现 web service 客户端](https://dev.liferay.com/zh/develop/tutorials/-/knowledge_base/6-2/soap-web-services#soap-php-client)

<br>

## SOAP JavaScript CLIENT

您可以用<font color="#FF6666">支持 Web Service 调用的任何语言编写客户端</font>。让我们调用我们在创建 Java 客户端时所做的相同操作，这次使用 JavaScript 客户端:

```javascript

```

请记住，您<font color="#FF6666">可以用任何支持使用 SOAP Web Service 的语言实现 web service 客户端</font>。要学习如何实现 OAuth，以便您可以访问第三方服务，请参见授权访问使用 OAuth 教程的服务。