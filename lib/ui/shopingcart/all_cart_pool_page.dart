import 'package:flutter/material.dart';
import 'package:flutter_app/constant/colors.dart';
import 'package:flutter_app/constant/fonts.dart';
import 'package:flutter_app/http_manager/api.dart';
import 'package:flutter_app/model/pagination.dart';
import 'package:flutter_app/ui/goods_detail/model/goodDetail.dart';
import 'package:flutter_app/ui/shopingcart/components/good_item_add_cart_widget.dart';
import 'package:flutter_app/ui/shopingcart/model/itemPoolBarModel.dart';
import 'package:flutter_app/ui/shopingcart/model/itemPoolModel.dart';
import 'package:flutter_app/component/back_loading.dart';
import 'package:flutter_app/component/sliver_footer.dart';
import 'package:flutter_app/component/tab_app_bar.dart';

///去凑单，未达到包邮条件
class AllCartItemPoolPage extends StatefulWidget {
  const AllCartItemPoolPage({Key key}) : super(key: key);

  @override
  _AllCartItemPoolPageState createState() => _AllCartItemPoolPageState();
}

class _AllCartItemPoolPageState extends State<AllCartItemPoolPage>
    with TickerProviderStateMixin {
  int _page = 1;
  int _pageSize = 10;

  bool _isLoading = true;
  bool _firstLoading = true;

  int _activeIndex = 0;
  TabController _mController;
  List<CategorytListItem> _categorytList = [];
  List<GoodDetail> _result = [];
  Pagination _pagination;
  int _id = 0;
  final _scrollController = ScrollController();
  ItemPoolModel _itemPoolModel;

  var _itemPoolBarModel = ItemPoolBarModel(0, '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mController = TabController(length: _categorytList.length, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_pagination != null) {
          if (_pagination.totalPage > _pagination.page) {
            setState(() {
              _page++;
            });
            _itemPool();
          }
        }
      }
    });
    _itemPool();
    _itemPoolBar();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabItem = [];
    for (int i = 0; i < (_categorytList.length); i++) {
      tabItem.add(_categorytList[i].categoryVO.name);
    }
    return Scaffold(
      appBar: TabAppBar(
        controller: _mController,
        tabs: tabItem,
        isScrollable: false,
        title: '${tabItem.length > 0 ? tabItem[_activeIndex] : ''}',
      ).build(context),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      child: _isLoading
          ? Loading()
          : Stack(
              children: [
                Positioned(
                  bottom: 50,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      GoodItemAddCartWidget(
                        dataList: _result,
                        addCarSuccess: () {
                          _itemPoolBar();
                        },
                      ),
                      SliverFooter(
                          hasMore: _pagination.totalPage > _pagination.page)
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 15),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '小计：¥${_itemPoolBarModel.subtotalPrice}',
                                style: t14redBold,
                              ),
                              Text(
                                '${_itemPoolBarModel.promTip.replaceAll('#', '')}',
                                style: t14black,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            height: double.infinity,
                            color: backRed,
                            alignment: Alignment.center,
                            child: Text(
                              '去购物车',
                              style: t16white,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _itemPool() async {
    Map<String, dynamic> params = {
      'promotionId': 0,
      'page': _page,
      'size': _pageSize,
      'sortType': 0,
      'descSorted': false,
      'source': 0,
      'categoryId': 0,
      'priceRangeId': _id,
    };
    var responseData = await itemPool(params);
    if (responseData.code == '200') {
      setState(() {
        _isLoading = false;
        _itemPoolModel = ItemPoolModel.fromJson(responseData.data);
        _categorytList = _itemPoolModel.categorytList;
        var searcherItemListResult = _itemPoolModel.searcherItemListResult;
        if (_page == 1) {
          _result.clear();
        }
        _result.addAll(searcherItemListResult.result);
        _pagination = searcherItemListResult.pagination;
      });
      _mController = TabController(
          length: _categorytList.length,
          vsync: this,
          initialIndex: _activeIndex);
      _mController.addListener(() {
        setState(() {
          _activeIndex = _mController.index;
          _id = _categorytList[_activeIndex].categoryVO.id;
          _page = 1;
          _itemPool();
        });
      });
    }
  }

  void _itemPoolBar() async {
    Map<String, dynamic> params = {'promotionId': 0};
    var responseData = await itemPoolBar(params);
    if (responseData.code == '200') {
      setState(() {
        _itemPoolBarModel = ItemPoolBarModel.fromJson(responseData.data);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mController.dispose();
    super.dispose();
  }
}
