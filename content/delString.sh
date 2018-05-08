#!/bin/bash

########################################################
#
# 该脚本是用来删除代码中指定字符串所在的那一行内容
# 删除代码中调试日志'console.log(data)'说明:
# 1、匹配规则：该脚本是匹配代码中所有的‘console.log’字符串，匹配到后将‘console.log’字符串所在行的内容删掉
# 2、执行脚本前先需要使用编辑器将代码中的错误日志（console.log(error);、console.log(err);）打印代码全局替换成其他字符串如'console1.log(error);',脚本执行完以后再替换回来
# 3、该脚本是删除'console.log'所在的一整行内容，若console.log()占两行或多行中则删除后的代码必定是错误的如‘src/app/pages/configurator/assetManage/assetManageCtrl.js’
#    中的 console.log(angular.element($event.target).parent('div').parent('li').parent('ol')
#           .siblings('.tree-node').find('img.collapsed1').attr('src', '../../../assets/img/3.png').parent().siblings().find('.edit').attr('src'));
#    所以执行该脚本前要删除这种代码
########################################################

delete(){
  for file in $1/*
    do
      if test -f $file
        then
          echo "Deal with file ${file} "
          sed -i "{/.*.*console.log.*/d}" ${file}
          if [ $? -ne 0 ];then
            echo "[Error]: delete \"\" from file ${file}."
          fi
      fi
      if test -d $file
        then
          delete $file
      fi
    done
}

delete ./src
exit