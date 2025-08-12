import { useState } from 'react'

import './App.css'
import ArticleDetail from './components/ArticleDetail'

function App() {
  const [count, setCount] = useState(0)

  return (
   <ArticleDetail />
  )
}

export default App
