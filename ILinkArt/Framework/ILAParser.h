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




#endif /* ILAParser_h */
