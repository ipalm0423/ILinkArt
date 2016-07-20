//
//  ILAParser.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#ifndef ILAParser_h
#define ILAParser_h


#define PARSERCategory @"var a=[];var category = document.body.getElementsByClassName('dropdown-sub-menu');for(i = 0;i<category.length;i++){var arr=[];for(j=0;j<category[i].childNodes.length;j++){if(category[i].childNodes[j].nodeType!==1){continue;}if(category[i].childNodes[j]['href']!==undefined){var dict = {name:'',url:''};dict.name=category[i].childNodes[j].innerText.trim();dict.url=category[i].childNodes[j]['href'].trim();arr.push(dict);}else{arr.push(category[i].childNodes[j].innerText.trim());}}a.push(arr);} JSON.stringify(a);"

#define PARSERNameAndIcon @"var dict = {user_name:'', avatar_url:''};dict.user_name = document.body.getElementsByClassName('artist-name')[0].innerText.trim();dict.avatar_url = document.body.getElementsByClassName('avatar-img center-block')[0].src.trim();JSON.stringify(dict);"

#define PARSERKartCount @"var dict = {cart_count:'', status:''};var user_action = document.body.getElementsByClassName('dropdown user pull-left');if(user_action.length > 0) {dict.cart_count = document.body.getElementsByClassName('s-no js-cart-counter')[0].innerText.trim();dict.status = '1';} else {dict.status = '0';};JSON.stringify(dict);"
#endif /* ILAParser_h */
