<template>
  <div class="max-w-4xl m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl float-left mb-4">All Posts</h3>
    <div class="group relative mb-4 float-right flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"><router-link to="/posts/create" class="link-grey">Add Post</router-link></div>
    <hr class="border border-grey-light my-6 clear-both" />

    <ul class="list-reset mt-4">
      <li class="py-4" v-for="post in posts" :key="post.id" :post="post">
        <div class="flex items-center border-gray-100 border-2 rounded-xl shadow-lg justify-between flex-wrap">
          <div class="float-right w-full">
         <button  v-if="user_id == post.user_id" class="bg-tranparent text-sm hover:bg-blue  text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
          @click.prevent="editpost(post)"><svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z" />
  <path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd" />
</svg></button>

          <button  v-if="user_id == post.user_id" class="bg-transprent text-sm hover:bg-red text-red  no-underline font-bold py-2 px-4 rounded border border-red"
         @click.prevent="removepost(post)"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
</svg></button>
</div>
          <img style="height:300px;width: 100%" class="" :src="post.photo" alt="">
          <p class="text-lg text-center w-full font-semibold">{{post.title}}</p>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Posts',
  data () {
    return {
      posts: [],
      error: '',
      user_id: 0
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.user_id = JSON.parse(localStorage.user).id
      this.$http.secured.get('/api/v1/posts')
        .then(response => { this.posts = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addpost () {
      const value = this.newpost
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/posts/', { post: { name: this.newpost.name } })
        .then(response => {
          this.posts.push(response.data)
          this.newpost = ''
        })
        .catch(error => this.setError(error, 'Cannot create post'))
    },
    removepost (post) {
      this.$http.secured.delete(`/api/v1/posts/${post.id}`)
        .then(response => {
          this.posts.splice(this.posts.indexOf(post), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete post'))
    },
    editpost (post) {
      var id = post.id
      this.$router.replace('/posts/edit/' + id)
    },
    updatepost (post) {
      this.editedpost = ''
      this.$http.secured.patch(`/api/v1/posts/${post.id}`, { post: { title: post.name } })
        .catch(error => this.setError(error, 'Cannot update post'))
    }
  }
}
</script>
