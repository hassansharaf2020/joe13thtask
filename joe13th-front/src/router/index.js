import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin.vue'
import Signup from '@/components/Signup.vue'
import Posts from '@/components/posts/Posts.vue'
import AddPosts from '@/components/posts/AddPosts.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/posts',
      name: 'Posts',
      component: Posts
    },
    {
      path: '/posts/create',
      name: 'CreatePosts',
      component: AddPosts
    },
    {
      path: '/posts/edit/:id',
      name: 'EditPosts',
      component: AddPosts
    },
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    }
  ]
})
