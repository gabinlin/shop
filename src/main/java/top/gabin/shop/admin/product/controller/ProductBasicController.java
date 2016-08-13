/**
 * Copyright (c) 2016 云智盛世
 * Created with ProductBasicController.
 */
package top.gabin.shop.admin.product.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import top.gabin.shop.core.jpa.criteria.service.query.CriteriaQueryService;
import top.gabin.shop.core.product.entity.Product;
import top.gabin.shop.core.product.service.ProductService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 *
 * @author linjiabin on  16/8/4
 */
@Controller
@RequestMapping("/admin/product/basic")
public class ProductBasicController {
    @Resource
    private ProductService productService;
    @Resource(name = "criteriaQueryService")
    private CriteriaQueryService queryService;
    private final static String DIR = "admin/product/basic/";

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public ModelAndView viewList() {
        ModelAndView modelAndView = new ModelAndView(DIR + "list");
        return modelAndView;
    }

    @RequestMapping(value = "/list", method = RequestMethod.POST)
    @ResponseBody
    public Map dataList(HttpServletRequest request) {
        return queryService.queryPage(Product.class, request, "id,defaultSku.name name,defaultSku.salePrice salePrice");
    }

    @RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
    public ModelAndView viewEdit(@PathVariable(value = "id") Long id) {
        ModelAndView modelAndView = new ModelAndView(DIR + "edit");
        if (id != null) {
            Product product = productService.getProduct(id);
            if (product != null) {
                modelAndView.addObject("product", product);
            }
        }
        return modelAndView;
    }



}
