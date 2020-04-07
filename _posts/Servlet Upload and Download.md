---
title: Servlet 文件上传和下载
date: 2017-4-26 11:16:30 
categories: Java
tags: 
- Servlet
- upload
- download
---

Servlet 实现上传和下载的依赖包：
- commons-fileupload-x.x.x.jar
- commons-io-x.x.x.jar
>x.x.x 为版本号

<!--more-->

## 文件上传

创建表单：在 form 表单中设置 enctype 属性,将表单作为一个字节流数据提交
```HTML
<form action="" method="post" enctype="multipart/form-data">
	...
</form>
```

创建 Servlet:
```Java
//1. 获取 FileItemFactory 类
FileItemFactory fif = new DiskFileItemFactory();//接口类，需要 new 实现类
//2. 获取 ServletFileUpload 类
ServletFileUpload sfu = new ServletFileUpload(fif);
//3. 解析 request 对象
List<FileItem> items = null;
try {
	items = sfu.parseRequest(request);
	for (FileItem item : items) {
		//判断 item 是否为普通的文本域
		if (item.ifFormField()) {
			//正常处理文本域
			String fieldName = item.getFieldName();//获取文本域的 name 属性值
			String fieldValue = item.getString("utf-8");//获取文本域的 value 属性值
		} else {//否则该 item 是文件
			//进行文件上传
			//1. 设置上传文件地址，获取文件夹绝对路径
			ServletContext app = request.getSession().getServletContext();
			String realPathapp.getRealPath("/文件夹名");
			//2. 获取文件名称
			String fileName = item.getName();
			System.out.println("文件路径: " + realPath + fileName);
			//3. 为了避免文件名冲突，添加时间戳或 UUID，这里添加 UUID
			int point = fileName.lastIndexOf(".");//获取点的位置
			String prefix = fileName.substring(0, point);//获取前缀
			String suffix = fileName.substring(point, fileName.length());//获取后缀
			System.out.println("前缀: " + prefix + ", 后缀： " + suffix);
			fileName = prefix + UUID.randomUUID() + suffix;//文件名结尾添加 UUID 唯一标识
			System.out.println("文件路径: " + realPath + fileName);
			//4. 上传文件
			String fileType item.getContentType();//获取上传文件的类型
			long size = item.getSize();//获取文件大小，单位（字节 B）
			if (type.indexOf("image") != -1 ) {//判断是否为图片，可
				File file = new File(realPath + File.separator + fileName);
				item.write(file);
			} else if (size <= 1 * 1024 * 1024){
				request.setAttribute("error","文件大小不能超过 1 M");
				request.getRequestDispa
			} else {
				request.setAttribute("error", "文件格式错误");
				request.getRequestDispatcher("").forward(request,response);//转发
			}
		}
	}
} catch (FileUploadException e) {
	e.printStackTrace();
} catch (Exception e) {
	e.printStackTrace();
}
```

<br/>
## 文件下载

HTML 超链接：
```HTML
<a href="<% path %>/download?filename=文件名.后缀名">下载</a>
```

创建 Servlet：
```Java
//获取需要下载的文件绝对路径
String fileName = request.getParameter("filename");
//设置编码格式，防止乱码
fileName = new String(fileName.getBytes("ISO-8859-1","utf-8"));
//获取下载文件夹的绝对路径
ServletContext app = request.getSession.getServletContext();
String realPath = app.getRealPath("/download");
//确定需要下载的文件对象
File file = new File(realPath + File.separator + fileName);
//读取 file 文件
InputStream in = new FileInputStream(file);
int len = 0;//每次读取的长度
byte[] buffer = new byte[1024];
//设置文件名编码格式
fileName = URLEncoder.encode(fileName,"utf-8"));
//设置文件下载头，指定浏览器以下载的方式打开。若不设置下载头则图片会显示在浏览器上而不是下载
response.setHeader("Content-disposition", "attachment;filename=" + fileName);
ServletOutputStream out = response.getOutputStream();
while ((len = in.read(buffer)) != -1) {
	//写出到浏览器
	out.write(buffer, 0, len);
}
out.close();
in.close();
```