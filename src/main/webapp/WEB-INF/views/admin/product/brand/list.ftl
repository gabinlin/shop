<html>
<head></head>
<body>
<div class="container">
    <div class="row">
        <div class="span24">
            <form id="searchForm" class="form-horizontal" tabindex="0" style="outline: none;">
                <div class="row">
                    <div class="control-group span8">
                        <label class="control-label">品牌名称：</label>
                        <div class="controls">
                            <input type="text" name="like_name" class="control-text">
                        </div>
                    </div>
                    <div class="form-actions span5">
                        <button id="btnSearch" type="submit" class="button button-primary">搜索</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="search-grid-container">
        <div id="grid">
        </div>
        <script src="http://g.tbcdn.cn/fi/bui/jquery-1.8.1.min.js"></script>
        <script src="http://g.tbcdn.cn/fi/bui/bui-min.js?t=201309041336"></script>
        <script type="text/javascript">
            BUI.use(['common/grid/format', 'common/search', 'common/page'], function(Format, Search, Page) {
                var editing = new BUI.Grid.Plugins.CellEditing({
                    triggerSelected : false //触发编辑的时候不选中行
                });
                var columns = [
                        {title:'品牌编号',dataIndex:'id',width:80,renderer:function(v){
                            return Search.createLink({
                                id : 'brand_edit_' + v,
                                title : '编辑品牌信息',
                                text : '编辑',
                                href : '/admin/product/brand/edit/' + v
                            });
                        }},
                        {title:'品牌名称',dataIndex:'name',width:200},
                        {title:'操作',dataIndex:'id',width:200,renderer : function(value,obj){
                            var editStr =  Search.createLink({ //链接使用 此方式
                                id : 'product_edit_' + value,
                                title : '编辑品牌信息',
                                text : '编辑',
                                href : '/admin/product/brand/edit/' + value
                            }),
                            delStr = '<span class="grid-command btn-del" title="删除品牌信息">删除</span>';//页面操作不需要使用Search.createLink
                            return editStr + delStr;
                        }}
                    ],
                    store = Search.createStore('/admin/product/brand/list', {
                        proxy : {
                            method : 'post'
                        }
                    }),
                    gridCfg = Search.createGridCfg(columns,{
                        tbar : {
                            items : [
                                {text : '<i class="icon-plus"></i>新建',btnCls : 'button button-small',handler:function(){alert('新建');}},
                                {text : '<i class="icon-edit"></i>编辑',btnCls : 'button button-small',handler:function(){alert('编辑');}},
                                {text : '<i class="icon-remove"></i>删除',btnCls : 'button button-small',handler : delFunction}
                            ]
                        },
                        plugins : [editing, BUI.Grid.Plugins.CheckSelection] // 插件形式引入多选表格
                    });
                var search = new Search({
                        store : store,
                        gridCfg : gridCfg,
                        formId: 'searchForm',
                        btnId: 'btnSearch'
                    }),
                    grid = search.get('grid');
                //删除操作
                function delFunction(){
                    var selections = grid.getSelection();
                    delItems(selections);
                }

                function delItems(items){
                    var ids = [];
                    BUI.each(items,function(item){
                        ids.push(item.id);
                    });

                    if(ids.length){
                        BUI.Message.Confirm('确认要删除选中的记录么？',function(){
                            $.ajax({
                                url : '../data/del.php',
                                dataType : 'json',
                                data : {ids : ids},
                                success : function(data){
                                    if(data.success){ //删除成功
                                        search.load();
                                    }else{ //删除失败
                                        BUI.Message.Alert('删除失败！');
                                    }
                                }
                            });
                        },'question');
                    }
                }

                //监听事件，删除一条记录
                grid.on('cellclick',function(ev){
                    var sender = $(ev.domTarget); //点击的Dom
                    if(sender.hasClass('btn-del')){
                        var record = ev.record;
                        delItems([record]);
                    }
                });
            });
        </script>
    </div>
</div>
</body>
</html>