import React from 'react';

const User = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-user">
        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
        <circle cx="12" cy="7" r="4"></circle>
    </svg>
);

const ArticleDetail = () => {
    return (
        <div className="bg-white">
            <div className="bg-white p-4 w-full">
                <div className="">
                    <h1 className="text-3xl flex">
                        De Hawzly<br />Gophobnet
                    </h1>
                    <div className="flex overflow-x-auto space-x-4 p-4 -mx-4 scrollbar-hide">
                        <div className="flex-none w-64 bg-yellow-200 text-yellow-800 p-16 rounded-4xl shadow-md">
                            <h3 className="font-semibold text-sm mb-1">Contemne ure Nodoveti</h3>
                            <p className="text-xs">Soet juxxt Ne...</p>
                        </div>
                        <div className="flex-none w-64 bg-blue-200 text-blue-800 p-16 rounded-4xl shadow-md">
                            <h3 className="font-semibold text-sm mb-1">Gok fovtting Faty</h3>
                            <p className="text-xs">Noitce ilng...</p>
                        </div>
                        <div className="flex-none w-64 bg-pink-200 text-pink-800 p-16 rounded-4xl shadow-md">
                            <h3 className="font-semibold text-sm mb-1">Kconna Erevretes</h3>
                            <p className="text-xs">Auasstillng Vok</p>
                        </div>
                        <div className="flex-none w-64 bg-green-200 text-green-800 p-16 rounded-4xl shadow-md">
                            <h3 className="font-semibold text-sm mb-1">New Card Title</h3>
                            <p className="text-xs">More content here...</p>
                        </div>
                    </div>

                    {/* Article Content */}
                    <article className="mt-6 text-gray-700 leading-relaxed">
                        <p className="mb-4">
                            Ao rao the ootmlaikvu loties thon cher yare proivrovaluo eneia yoakxaplvthruo porwahy prasikins acroihieh oer ooflictmel theoos poreilseoitles tie a fecoiooee sa aroout trus a
                            neod tiotaraninnin, aoollikel xua oinett oad chtingains rao tlahe foikire tueckw wutfthe tlnctiop plustling suleraiding cie tberdoing podgaavlie pane ulven we fia toeadis, d he
                            nertt aulumrnuniho tihath eogeenaer lihe, oprapitivi vie worioe tthe writaty a witeo, tes thevihwuuirruine tneike enptaltennas attsei oer ine pimaroa zog troeeo aohl o tle
                            soodckva toortstathinisriodod he faoultehe paeiety arh tteromiste leerboosen.
                        </p>
                        <p className="mb-4">
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
                            exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
                            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                        </p>
                    </article>

                    {/* Action Buttons */}
                    <div className="flex space-x-4 mt-6">
                        <button className="flex-1 bg-gray-900 text-white font-bold py-3 rounded-full shadow-md hover:bg-gray-700 transition-colors duration-200">
                            Continue reading
                        </button>
                        <button className="flex-1 border border-gray-400 text-gray-800 font-bold py-3 rounded-full shadow-md hover:bg-gray-100 transition-colors duration-200">
                            Report
                        </button>
                    </div>
                </div>

                {/* Footer */}
                <footer className="flex justify-center text-gray-500 text-xs py-4 space-x-6">
                    <span>Copyright</span>
                    <span>Terms of Service</span>
                    <span>Privacy Policy</span>
                </footer>
            </div>
        </div>
    );
};

export default ArticleDetail;