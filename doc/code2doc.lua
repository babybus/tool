module(...,package.seeall)

local app_info = require("config")
local pro_name = app_info.pro_name
local app_list = app_info.app_list

function current_path()
  os.execute("cd > cd.tmp")
  local f = io.open("cd.tmp", r)
  local cwd = f:read("*a")
  f:close()
  os.remove("cd.tmp")
  return string.sub(cwd, 1, -2)
end

local work_path = current_path()

function open_file(file_path,file_name,mode)

	file_path = work_path ..'\\' ..  file_path
	--print(file_path,work_path,file_name,file_path ..'\\' .. file_name)
	os.execute('MD '.. file_path)
	local file = io.open(file_path .. '\\' .. file_name,mode)
	assert(file)
	return file
end

function css_style()
	local html = [[
		<style type="text/css">
			body{
				font-size:14px;
			}
			.method{
				color:#060;
			}
			.method_des{
				color:#060;
				margin-left:40px;
				font-size:16px;
			}
			.class_method{
				color:blue;
				margin-left:40px;
				font-size:16px;
				line-height: 1.5;
			}
			.class_method a{
				margin:auto;
			}
			.class_member{
				color:blue;
				margin-left:40px;
				font-size:16px;
			}
			.class_des{
				color:#060;
				margin-left:40px;
				font-size: 14px;
			}
			p{
				font-size: 14px;
				margin: auto;
				line-height: 1.5;
			}
			h1{
				font-size: 25px;
				color: white;
				background-color: rgb(79,129,189);
			}
			h2{
				margin: 10px 5px 5px 15px;
				padding: 5px;
				background: rgb(149,179,215);
				color: #fff;
				font-size: 15px;
				font-weight: normal;
			}
		</style>
	]]
	return html
end
--生成框架
function generate_frame()
	local html = '<html>\n'
	html = html ..[[
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>frame</title>
		<style type="text/css">
			body{
				font-size:14px;
			}
			.chapter a{
				font-size:14px;
			}
		</style>
	</head>
	]]
	html = html ..string.format([[
	<frameset border=4 rows="50,*">
		<frame src="%s/nav.html">
		<frameset border=4 cols="250,*" >
			<frame name="modframe">
			<frame src="%s/showframe.html" name="showframe" marginWidth=5 marginHeight=5>
		</frameset>
	</frameset>
	]],pro_name,pro_name)
	html = html .. '</html>\n'

	return html
end

function generate_method(method_info,path)
	local example = ""
	local es = method_info.examples
	for _,e in pairs(es) do
		local intro = e.intro

		example = example .. string.gsub(intro,"\n",[[<br>]]) .. [[<br>]]
	end
	local param = [[
	<table border="1" cellspacing="0" cellpadding="0" summary="">]]
	local ps = method_info.params
	for _,p in pairs(ps) do
		param = param .. string.format([[
		<tr>
			<td valign="top" width="100"><p align="center">%s </p></td>
			<td valign="top" width="100"><p align="center">%s </p></td>
			<td valign="top" width="400"><p align="center">%s </p></td>
		</tr>
		]],p.name,p.type,p.intro)
	end
	param = param .. [[</table>]]
	local ret = [[
	<table border="1" cellspacing="0" cellpadding="0" summary="">]]
	local rs = method_info.returns
	for _,r in pairs(rs) do
		ret = ret .. string.format([[
		<tr>
			<td valign="top" width="100"><p align="center">%s </p></td>
			<td valign="top" width="400"><p align="center">%s </p></td>
		</tr>
		]],r.type,r.intro)
	end
	ret = ret .. [[</table>]]
	local html = '<html>\n'
	html = html .. [[
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">]] .. css_style()
	html = html .. string.format([[
		<h1> %s </h1>
		<h2> 简单描述 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 详细描述 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 注意点 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 用法 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 使用示例 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 参数 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
		<h2> 返回值 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>

		<h2> 相关链接 </h2>
		<div class="method_des">
		<p>%s</p>
		</div>
	]],method_info.name,method_info.brief,method_info.intro,method_info.notice,string.gsub(method_info.usage,"\n",[[<br>]]),	example,param,ret	,method_info.link)
	html = html .. '</html>\n'
	local method_file = open_file(pro_name .. '\\' .. string.gsub(path,"/","\\"),method_info.name .. ".html","w+")
	method_file:write(html)
	method_file:close()
end

function generate_class(path,class_info)
	local html = '<html>\n'
	html = html ..[[
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>mod</title>]] .. css_style() .. [[
	</head>
	<div class="body">
	]]
	local fields = class_info.fields
	local member = [[
	<table border="1" cellspacing="0" cellpadding="0" summary="">]]
	for _,field in pairs(fields) do
		member = member .. string.format([[
		<tr>
			<td valign="top" width="100"><p align="center">%s </p></td>
			<td valign="top" width="100"><p align="center">%s </p></td>
			<td valign="top" width="400"><p align="center">%s </p></td>
		</tr>
		]],field.name,field.type,field.intro)
	end
	member = member .. [[</table>]]
	local method = ""
	local ms = class_info.methods
	for _,m in pairs(ms) do
		method = method .. string.format([[<a href='%s.html' target='showframe'>%s</a><br>]],class_info.name .. "/" .. m.name,m.name)
		generate_method(m,path .. "/" .. class_info.name)
	end
	html  = html .. string.format([[
		<h1> %s</h1>
		<h2> 简单描述 </h2>
		<div class="class_des">
		<p>%s</p>
		</div>
		<h2> 详细描述 </h2>
		<div class="class_des">
		<p>%s</p>
		</div>
		<h2> 类方法 </h2>
		<div class="class_method">
		<p>%s</p>
		</div>
		<h2> 类成员 </h2>
		<div class="class_member">
		<p>%s</p>
		</div>
		<h2> 相关链接 </h2>
		<div class="class_des">
		<p>%s</p>
		</div>]],
		class_info.name,	class_info.brief,	class_info.intro,	method,	member,	class_info.link).. [[
		</div>
	</html>]]
	local class_file = open_file(pro_name .. '\\' .. string.gsub(path,"/","\\"),class_info.name .. ".html",'w+')
	class_file:write(html)
	class_file:close()
end

function get_children_html(id,children_info,path)
	local html = ""
	local pid = id - 1

	local children = children_info or {}
	for _,child_info in pairs(children) do
		local child_name = child_info.name
		local url = path
		if child_info.brief then						--有简短描述-->>产生child_name.html
			url = '../' .. url .. '/' .. string.format('%s.html',child_name)
			generate_class(path,child_info)
		else
			url = ""
		end

		html = html .. string.format([[d.add(%d,%d,"%s","%s");]],id,pid,child_name, url)  .. '\n'
		id = id + 1
		html = html ..  get_children_html(id,child_info.children,path .. '/' .. child_name)
	end
	return html
end

function generate_app_nav(app_name,children_info)
	local id = 1
	local html = string.format([[
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link rel="StyleSheet" href="dtree.css"  type="text/css" />
			<script type="text/javascript" src="dtree.js" ></script>
		</head>
		<title>%s</title>
		<body>
		<div class=dtree>
		<script type="text/javascript">
			d = new dTree("d");
		d.add(0,-1,"%s","");
	]],app_name,app_name) .. get_children_html(id,children_info, app_name) ..[[
		document.write(d);
		</script>
	</div>
<p \><hr size="1" \>
<br><br><br>
</body>
</html>]]
	return html
end

--生成导航
function generate_nav()
	local nav_html = [[
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>frame</title>
		<style type="text/css">
			body{
				font-size:14px;
			}
			.menu{
				margin-left:60px;
				list-style-type:none;
			}
			.chapter{
				float:left;
				margin-left:20px;
				font-size:20px;
			}
			.chapter a{
				text-decoration: none;
			}

		</style>
	</head>
	<div id="nav">
	<ul id="menu" class="menu">]]
	for app_name,app_info in pairs(app_list) do
		nav_html = nav_html .. string.format([[
		<li id=%s class="chapter">
			<a href="nav/%s.html" target='modframe'>%s</a>
		</li>]],app_name,app_name,app_name
		)
		local app_nav_html = generate_app_nav(app_name,app_info.children)
		local app_nav_file = open_file(pro_name .. '\\nav\\', app_name ..'.html', 'w+')
		app_nav_file:write(app_nav_html)
		app_nav_file:close()
	end
	nav_html = nav_html .. [[
	</ul>
	</div>
</html>]]
	return nav_html
end

--生成showframe.html
function generate_show_frame()
	local html = '<html>\n'
	html = html ..[[
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>index</title>
		<style type="text/css">
		</style>
	]]
	html = html .. '</html>\n'
	return html
end


function run()
	print(string.format("generate start ... \n pro_name %s \n",pro_name))
	local fram_html = generate_frame()
	local fram_file = open_file('','index.html', 'w+')
	fram_file:write(fram_html)
	fram_file:close()

	local show_frame_html = generate_show_frame()
	local show_frame_file = open_file(pro_name,'showframe.html', 'w+')
	show_frame_file:write(show_frame_html)
	show_frame_file:close()

	local nav_html = generate_nav()
	local nav_file = open_file(pro_name,'nav.html', 'w+')
	nav_file:write(nav_html)
	nav_file:close()

    local path = string.format("xcopy /E /Y css_bk %s",pro_name .. [[\nav]])
    print(path)
    os.execute(path)
    os.execute("del tmp_data.lua")


	print("generate end.")
end



