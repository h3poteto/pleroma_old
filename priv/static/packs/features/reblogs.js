(window.webpackJsonp=window.webpackJsonp||[]).push([[38],{691:function(t,s,e){"use strict";e.r(s),e.d(s,"default",function(){return v});var a,o,n,r=e(1),c=e(6),p=e(2),i=(e(3),e(20)),u=e(24),d=e(5),l=e.n(d),b=e(26),h=e.n(b),m=e(291),f=e(56),j=e(7),O=e(888),I=e(641),w=e(643),y=e(642),v=Object(i.connect)(function(t,s){return{accountIds:t.getIn(["user_lists","reblogged_by",s.params.statusId])}})((n=o=function(t){function s(){return t.apply(this,arguments)||this}Object(c.a)(s,t);var e=s.prototype;return e.componentWillMount=function(){this.props.dispatch(Object(f.m)(this.props.params.statusId))},e.componentWillReceiveProps=function(t){t.params.statusId!==this.props.params.statusId&&t.params.statusId&&this.props.dispatch(Object(f.m)(t.params.statusId))},e.render=function(){var t=this.props,s=t.shouldUpdateScroll,e=t.accountIds;if(!e)return Object(r.a)(I.a,{},void 0,Object(r.a)(m.a,{}));var a=Object(r.a)(j.b,{id:"status.reblogs.empty",defaultMessage:"No one has boosted this toot yet. When someone does, they will show up here."});return Object(r.a)(I.a,{},void 0,Object(r.a)(w.a,{}),Object(r.a)(y.a,{scrollKey:"reblogs",shouldUpdateScroll:s,emptyMessage:a},void 0,e.map(function(t){return Object(r.a)(O.a,{id:t,withNote:!1},t)})))},s}(u.a),Object(p.a)(o,"propTypes",{params:l.a.object.isRequired,dispatch:l.a.func.isRequired,shouldUpdateScroll:l.a.func,accountIds:h.a.list}),a=n))||a}}]);
//# sourceMappingURL=reblogs.js.map