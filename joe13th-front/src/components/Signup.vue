<template>
  <div class="max-w-xl m-auto my-8">
    <div class="border p-10 border-grey-light shadow rounded">
      <form @submit.prevent="signup">
        <div class="flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
          <div class="bg-red-500 p-2.5 rounded-md" v-if="error">{{ error }}</div>
          <div>
            <img class="mx-auto h-12 w-auto" src="https://www.joe13th.com/img/logo.b898d609.png" alt="Workflow">
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
              Sign Up
            </h2>
          </div>
        <input type="hidden" name="remember" value="true">
      <div class="rounded-md shadow-sm -space-y-px">
        <div>
          <label for="f_name" >First Name</label>
          <input id="f_name" v-model="f_name" name="f_name" type="text" autocomplete="f_name" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="First Name">
        </div>
        <div>
        <label for="l_name" >Last Name</label>
          <input id="l_name" v-model="l_name" name="l_name" type="text" autocomplete="l_name" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Last Name">
        </div>

        <div>
          <label for="email-address" >Email address</label>
          <input id="email-address" v-model="email" name="email" type="email" autocomplete="email" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Email address">
        </div>
        <div>
          <label for="password" >Password</label>
          <input id="password" v-model="password" name="password" type="password" autocomplete="current-password" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Password">
        </div>

        <div>
          <label for="password_confirmation" >Password Confirmation</label>
          <input id="password_confirmation" v-model="password_confirmation" name="password_confirmation" type="password" autocomplete="current-password_confirmation" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="password_confirmation">
        </div>
        <div>
          <label for="password_confirmation" >Profile Image</label>
          <input class="block" required type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
          <img v-if="priview" :src="priview" style="width:200px;">
        </div>
      </div>
        <div>
        <button type="submit" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
          <span class="absolute left-0 inset-y-0 flex items-center pl-3">
            <!-- Heroicon name: solid/lock-closed -->
            <svg class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
            </svg>
          </span>
          Sign Up
        </button>
      </div>

          <div class="flex items-center justify-between">

          <div class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-300 hover:bg-indigo-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"><router-link to="/" class="link-grey">Sign In</router-link></div>
      </div>
        </div>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      f_name: '',
      l_name: '',
      email: '',
      password: '',
      password_confirmation: '',
      avatar: '',
      priview: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', { first_name: this.f_name, last_name: this.l_name, email: this.email, password: this.password, password_confirmation: this.password_confirmation, avatar: this.avatar })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/posts')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    setavatar (response) {
      this.avatar = response.data.avatar
      this.priview = response.data.url
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/posts')
      }
    },
    handleFileUpload () {
      this.file = this.$refs.file.files[0]
      let formData = new FormData()
      formData.append('file', this.file)
      formData.append('folder', 'profile')
      this.$http.fromdata.post('/uploadimages', formData, { headers: { 'Content-Type': 'multipart/form-data' } }).then(response => this.setavatar(response)).catch(function () { this.avatar = '' })
    }
  }
}
</script>
