import React from 'react'

const mockContent = [
  {
    id: 1,
    description: "Desenvolvedor front-end apaixonado por criar interfaces modernas.",
    imageUrl: "https://randomuser.me/api/portraits/men/32.jpg"
  },
  {
    id: 2,
    description: "UX Designer focada em tornar experiências mais humanas.",
    imageUrl: "https://randomuser.me/api/portraits/women/44.jpg"
  },
  {
    id: 3,
    description: "Especialista em back-end com experiência em Node.js e bancos de dados.",
    imageUrl: "https://randomuser.me/api/portraits/men/67.jpg"
  },
  {
    id: 4,
    description: "Product Owner dedicada a alinhar visão de negócios e tecnologia.",
    imageUrl: "https://randomuser.me/api/portraits/women/12.jpg"
  },
  {
    id: 5,
    description: "QA Engineer com foco em automação de testes e qualidade de software.",
    imageUrl: "https://randomuser.me/api/portraits/men/85.jpg"
  },
  {
    id: 6,
    description: "Especialista em marketing digital e estratégias de conteúdo.",
    imageUrl: "https://randomuser.me/api/portraits/women/21.jpg"
  },
  {
    id: 7,
    description: "DevOps com experiência em pipelines CI/CD e infraestrutura na nuvem.",
    imageUrl: "https://randomuser.me/api/portraits/men/54.jpg"
  }
];


const ContentCards = () => {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-5 ">
      {mockContent.map(({ id, description, imageUrl }) => (
        <div key={id} className="bg-[#E4F4F3] border rounded-lg flex flex-col p-4">
          <div className='flex justify-end'>
            <img src="star.svg" alt="star" className="w-6 h-6 bg-white rounded-full p-1 cursor-pointer" />
          </div>
          <div className='flex'>
           <img src={imageUrl} alt={`Content ${id}`} className="w-20 h-20 object-cover rounded-full mr-4" />
            <p className="text-gray-800">{description}</p>
          </div>
          
        </div>
      ))}
    </div>

  )
}


export default ContentCards
