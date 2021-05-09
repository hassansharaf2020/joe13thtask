<template>
  <div class="max-w-2xl m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">All Posts</h3>
    <form action="" @submit.prevent="savepost">
      <div>
          <label for="title" >Title</label>
          <input id="title" v-model="title" name="title" type="text" autocomplete="title" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Title">
        </div>
        <div>
        <label for="desc" >Description</label>
          <textarea id="desc" v-model="desc" name="desc" type="text" autocomplete="desc" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Description" rows="10"></textarea>
        </div>

         <div class="m-5">
          <label for="password_confirmation" >Profile Image</label>
          <input class="block" v-if="id == ''" required type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
          <input class="block" v-if="id != ''" type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
          <img v-if="priview" :src="priview" style="width:200px;">
        </div>

      <input type="submit" v-if="id == ''" value="Add post" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" />

      <input type="submit" v-if="id != ''" value="Update Post" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-500 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" />

    </form>

    <hr class="border border-grey-light my-6" />
  </div>
</template>

<script>
export default {
  name: 'AddPosts',
  data () {
    return {
      id: '',
      title: '',
      desc: '',
      error: '',
      avatar: '',
      priview: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      if (this.$route.params.id) {
        this.id = this.$route.params.id
        this.$http.secured.get('/api/v1/posts/' + this.id)
          .then(response => { this.setdata(response.data) })
          .catch(error => this.setError(error, 'Something went wrong'))
      }
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    setdata (data) {
      this.title = data.title
      this.desc = data.description
      this.avatar = data.photo
      this.priview = data.photo
    },
    savepost () {
      const value = this.title
      if (!value) { return }
      if (this.id !== '') {
        this.$http.secured.put('/api/v1/posts/' + this.id, {title: this.title, description: this.desc, photo: this.avatar}).then(response => {
          this.error = ''
          this.$router.replace('/posts')
        }).catch(error => this.setError(error, 'Cannot create post'))
      } else {
        this.$http.secured.post('/api/v1/posts/', {title: this.title, description: this.desc, photo: this.avatar}).then(response => {
          this.error = ''
          this.$router.replace('/posts')
        }).catch(error => this.setError(error, 'Cannot create post'))
      }
    },
    setavatar (response) {
      this.avatar = response.data.avatar
      this.priview = response.data.url
    },
    handleFileUpload () {
      this.file = this.$refs.file.files[0]
      let formData = new FormData()
      formData.append('file', this.file)
      formData.append('folder', 'posts')
      this.$http.fromdata.post('/uploadimages', formData, { headers: { 'Content-Type': 'multipart/form-data' } }).then(response => this.setavatar(response)).catch(function () { this.avatar = '' })
    }
  }
}
</script>
